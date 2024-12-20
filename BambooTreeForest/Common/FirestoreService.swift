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
        db.collection("posts").getDocuments { snapshot, error in
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
}
