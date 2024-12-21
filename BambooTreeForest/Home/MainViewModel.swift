//
//  MainViewModel.swift
//  BambooTreeForest
//
//  Created by softourr on 12/20/24.
//

import Foundation

class MainViewModel {
    private let firestoreService = FirestoreService()
    var posts: [(id:String, title: String, createdAt: String, content: String, commentCount: Int, isLiked: Bool)] = []

    func fetchPosts(completion: @escaping () -> Void) {
        firestoreService.fetchPosts { [weak self] fetchedPosts in
            self?.posts = fetchedPosts
            completion()
        }
    }
}
