//
//  FirestoreService.swift
//  BambooTreeForest
//
//  Created by softourr on 12/20/24.
//

import FirebaseFirestore

class FirestoreService {
    private let db = Firestore.firestore()
    
    func fetchPosts(completion: @escaping ([(id: String, title: String, createdAt: String, content: String, commentCount: Int, isLiked: Bool)]) -> Void) {
        db.collection("posts")
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
            if let error = error {
                print("Firestore 데이터 가져오기 실패: \(error)")
                completion([])
                return
            }
            // 실제 Firestore에서 가져온 문서 개수 출력
            let documentCount = snapshot?.documents.count ?? 0
            print("총 문서 개수: \(documentCount)")
            
            let posts = snapshot?.documents.compactMap { doc -> (String, String, String, String, Int, Bool)? in
                let id = doc.data()["id"] as? String ?? doc.documentID // id 필드가 없으면 문서 ID 사용
                let data = doc.data()

                // 필드 기본값 설정
                let title = data["title"] as? String ?? "제목 없음"
                let createdAt = data["createdAt"] as? String ?? "날짜 없음"
                let content = data["content"] as? String ?? "내용 없음"
                let commentCount = data["commentCount"] as? Int ?? 0
                let isLiked = data["isLiked"] as? Bool ?? false
                
                return (id, title, createdAt, content, commentCount, isLiked)
            } ?? []
            print("유효한 문서 개수: \(posts.count)")
            completion(posts)
        }
    }
    // id 필드 추가 메서드
    private func addIdFieldToDocument(docId: String) {
        db.collection("posts").document(docId).updateData(["id": docId]) { error in
            if let error = error {
                print("Firestore 문서 ID 추가 실패: \(error)")
            } else {
                print("Firestore 문서 ID 추가 성공: \(docId)")
            }
        }
    }
// MARK: - Comments
    func fetchPost(withId id: String, completion: @escaping ([String: Any]?) -> Void) {
        db.collection("posts").document(id).getDocument { document, error in
            if let error = error {
                print("포스트 가져오기 실패: \(error)")
                completion(nil)
                return
            }
            completion(document?.data())
        }
    }
    /// 특정 포스트에 해당하는 댓글 데이터를 가져오는 함수
    func fetchComments(forPostId postId: String, completion: @escaping ([[String: Any]]) -> Void) {
        db.collection("comments").whereField("postId", isEqualTo: postId)
            .order(by: "createdAt", descending: false) // 최신 댓글이 상단에 위치하도록 정렬
            .getDocuments { snapshot, error in
            if let error = error {
                print("댓글 데이터 가져오기 실패: \(error)")
                completion([])
                return
            }
            
            // 댓글 데이터 매핑
            let comments = snapshot?.documents.map { doc -> [String: Any] in
                var data = doc.data()
                // commentId 필드가 없으면 Firestore 문서 ID로 설정
                data["commentId"] = data["commentId"] ?? "댓글id없다"
                return data
            } ?? []
    
            print("가져온 댓글 개수: \(comments.count)")
            completion(comments)
        }
    }
    
    /// 댓글  추가  함수
    func addComment(toPostId postId: String, commentData: [String: Any], completion: @escaping (Bool) -> Void) {
        var newCommentData = commentData
        newCommentData["postId"] = postId // postId 추가
        newCommentData["commentId"] = UUID().uuidString // UUID로 commentId 생성 및 추가
        newCommentData["createdAt"] = FieldValue.serverTimestamp() // Firestore 서버 타임스탬프 추가
        
        db.collection("comments").addDocument(data: newCommentData) { error in
            if let error = error {
                print("❌ 댓글 추가 실패: \(error)")
                completion(false)
            } else {
                print("✅ 댓글 추가 성공: \(newCommentData)")
                // 댓글 추가 성공 후 commentCount 증가
                self.incrementCommentCount(forPostId: postId) { success in
                    if success {
                        print("✅ commentCount 증가 성공")
                    } else {
                        print("❌ commentCount 증가 실패")
                    }
                    completion(success)
                }
            }
        }
    }

    func incrementCommentCount(forPostId postId: String, completion: @escaping (Bool) -> Void) {
        let postRef = db.collection("posts").document(postId)
        
        postRef.updateData([
            "commentCount": FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                print("❌ commentCount 증가 실패: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func deleteComment(postId: String, commentId: String, completion: @escaping (Bool) -> Void) {
        let commentsCollection = Firestore.firestore().collection("comments")
        let postsCollection = Firestore.firestore().collection("posts")
        
        print("🔍 삭제 요청된 postId: \(postId), commentId: \(commentId)")
        
        // postId와 commentId로 문서 찾기
        commentsCollection
            .whereField("postId", isEqualTo: postId)
            .whereField("commentId", isEqualTo: commentId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ 댓글 찾기 실패: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("❌ 해당 postId와 commentId를 가진 댓글을 찾을 수 없습니다.")
                    completion(false)
                    return
                }
                
                // 첫 번째 문서를 삭제
                let document = documents.first
                document?.reference.delete { error in
                    if let error = error {
                        print("❌ 댓글 삭제 실패: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("✅ 댓글 삭제 성공")
                        // commentCount 감소
                        postsCollection.document(postId).updateData([
                            "commentCount": FieldValue.increment(Int64(-1)) // commentCount를 1 감소
                        ]) { error in
                            if let error = error {
                                print("❌ commentCount 감소 실패: \(error.localizedDescription)")
                            } else {
                                print("✅ commentCount 감소 성공")
                            }
                        }
                        
                        completion(true)
                        completion(true)
                    }
                }
            }
    }


    
}
