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
            
            let posts = snapshot?.documents.compactMap { doc -> (String, String, String, String, Int, Bool)? in
                let id = doc.documentID // 문서 ID
                let data = doc.data()
                // 문서에 id 필드가 없는 경우 추가
                if data["id"] == nil {
                    self.addIdFieldToDocument(docId: id)
                }
                
                guard
                    let title = data["title"] as? String,
                    let createdAt = data["createdAt"] as? String,
                    let content = data["content"] as? String,
                    let commentCount = data["commentCount"] as? Int,
                    let isLiked = data["isLiked"] as? Bool
                else { return nil }
                
                return (id, title, createdAt, content, commentCount, isLiked)
            } ?? []
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
