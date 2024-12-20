//
//  FirestoreService.swift
//  BambooTreeForest
//
//  Created by softourr on 12/20/24.
//

import FirebaseFirestore

class FirestoreService {
    private let db = Firestore.firestore()

    func fetchPosts(completion: @escaping ([(title: String, createdAt: String, content: String, commentCount: Int, isLiked: Bool)]) -> Void) {
        db.collection("posts").getDocuments { snapshot, error in
            if let error = error {
                print("Firestore 데이터 가져오기 실패: \(error)")
                completion([])
                return
            }

            let posts = snapshot?.documents.compactMap { doc -> (String, String, String, Int, Bool)? in
                let data = doc.data()

                guard
                    let title = data["title"] as? String,
                    let createdAt = data["createdAt"] as? String,
                    let content = data["content"] as? String,
                    let commentCount = data["commentCount"] as? Int,
                    let isLiked = data["isLiked"] as? Bool
                else { return nil }

                return (title, createdAt, content, commentCount, isLiked)
            } ?? []
            completion(posts)
        }
    }
}
