//
//  CommentViewController.swift
//  BambooTreeForest
//
//  Created by 오정환 on 12/19/24.
//

import UIKit
import FirebaseFirestore

class CommentViewController: UIViewController {
    
    let db = FirestoreService() // FirestoreService 사용
    
    // Background View
    let backgroundView: BackgroundView = {
        let view = BackgroundView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let logoImageView: UIImageView = {
            let logoImage = UIImageView()
            logoImage.image = UIImage(named: "Logo")
            logoImage.contentMode = .scaleAspectFit // 비율 유지하며 축소/확대
            logoImage.translatesAutoresizingMaskIntoConstraints = false
            return logoImage
        }()
    
    let myView: UIView = CommentUIComponents.createMyView()
    lazy var scrollView: UIScrollView = {
        return CommentUIComponents.createScrollView(with: myView)
    }()
    
    let titleLabel: UILabel = CommentUIComponents.createTitleLabel()
    let dateLabel: UILabel = CommentUIComponents.createDateLabel()
    let underlineView: UIView = CommentUIComponents.createUnderlineView()
    let commentsStackView: UIStackView = CommentUIComponents.createCommentsStackView()
    
    // Data Properties
    var receivedId: String? // 전달받은 ID를 저장할 변수
    var postData: [String: Any]? // 가져온 데이터를 저장할 변수
    var comments: [[String: Any]] = [] // 댓글 데이터를 저장할 배열
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 전달받은 ID 확인
        if let id = receivedId {
            print("받은 ID: \(id)")
            fetchPostData(withId: id)
            fetchComments(forPostId: id)
        } else {
            print("ID를 전달받지 못했습니다.")
        }
        
        setupUI()
    }
    
    private func fetchPostData(withId id: String) {
        db.fetchPost(withId: id) { [weak self] data in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let data = data {
                    self.postData = data
                    self.updateUI()
                } else {
                    print("문서를 찾을 수 없습니다.")
                }
            }
        }
    }
    
    private func fetchComments(forPostId postId: String) {
        db.fetchComments(forPostId: postId) { [weak self] comments in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.comments = comments
                self.updateCommentsUI()
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        // 로고
        view.addSubview(logoImageView)
            NSLayoutConstraint.activate([
                logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor), // 가운데 정렬
                logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20), // 상단 여백
                logoImageView.widthAnchor.constraint(equalToConstant: 120),
                logoImageView.heightAnchor.constraint(equalToConstant: 120)
            ])
        
        // ScrollView 추가
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10), // 로고 아래 위치
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor), // 가운데 정렬
            scrollView.widthAnchor.constraint(equalToConstant: 340), // 너비 제한
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20) // 하단 여백
        ])
        
        // MyView를 ScrollView에 추가
        scrollView.addSubview(myView)
        NSLayoutConstraint.activate([
            myView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            myView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            myView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            myView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            myView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // ScrollView 폭에 맞춤
        ])

        myView.addSubview(titleLabel)
        myView.addSubview(dateLabel)
        myView.addSubview(underlineView)
        
        NSLayoutConstraint.activate([
            // Title constraints
            titleLabel.topAnchor.constraint(equalTo: myView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateLabel.leadingAnchor, constant: -10),
            
            // Date constraints
            dateLabel.trailingAnchor.constraint(equalTo: myView.trailingAnchor, constant: -20),
            dateLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            // Underline constraints
            underlineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            underlineView.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: 20),
            underlineView.trailingAnchor.constraint(equalTo: myView.trailingAnchor, constant: -20),
            underlineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        myView.addSubview(commentsStackView)
        NSLayoutConstraint.activate([
            commentsStackView.topAnchor.constraint(equalTo: underlineView.bottomAnchor, constant: 20),
            commentsStackView.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: 20),
            commentsStackView.trailingAnchor.constraint(equalTo: myView.trailingAnchor, constant: -20),
            commentsStackView.bottomAnchor.constraint(lessThanOrEqualTo: myView.bottomAnchor, constant: -20)
        ])
    }
    
    private func updateUI() {
        guard let postData = postData else { return }
        titleLabel.text = postData["title"] as? String ?? "제목 없음"
        dateLabel.text = postData["createdAt"] as? String ?? "날짜 없음"
    }
    
    private func updateCommentsUI() {
        commentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if comments.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "작성된 댓글이 없습니다."
            emptyLabel.font = UIFont.systemFont(ofSize: 16)
            emptyLabel.textColor = .lightGray
            emptyLabel.textAlignment = .center
            commentsStackView.addArrangedSubview(emptyLabel)
        } else {
            for comment in comments {
                guard let name = comment["name"] as? String, let content = comment["comment"] as? String else { continue }
                let commentView = createCommentView(name: name, content: content)
                commentsStackView.addArrangedSubview(commentView)
            }
        }
    }
    
    private func createCommentView(name: String, content: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let bubbleView = UIView()
        bubbleView.backgroundColor = UIColor(hex: "#F8F8F8")
        bubbleView.layer.cornerRadius = 10
        bubbleView.translatesAutoresizingMaskIntoConstraints = false

        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont(name: "Kodchasan-Light", size: 14)
        // nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let contentLabel = UILabel()
        contentLabel.text = content
        // contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.font = UIFont(name: "Kodchasan-Light", size: 14)
        contentLabel.textColor = .black
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false

        bubbleView.addSubview(nameLabel)
        bubbleView.addSubview(contentLabel)
        containerView.addSubview(bubbleView)

        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: containerView.topAnchor),
            bubbleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bubbleView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bubbleView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            nameLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -10),

            contentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            contentLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10),
            contentLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -10),
            contentLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10)
        ])

        return containerView
    }
}
