//
//  CommentViewController.swift
//  BambooTreeForest
//
//  Created by 오정환 on 12/19/24.
//

import UIKit

class CommentViewController: UIViewController {
    
    let db = Firestore.firestore() // Firestore 초기화
    
    let imageView: UIImageView = {
        let aImageView = UIImageView()
        aImageView.image = UIImage(named: "Frame")
        aImageView.contentMode = .scaleAspectFill
        aImageView.clipsToBounds = true
        aImageView.translatesAutoresizingMaskIntoConstraints = false
        return aImageView
    }()
    
    let myView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#111C32")
        view.layer.cornerRadius = 30
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let logoImageView: UIImageView = {
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "Logo") // 'Logo'라는 이미지 이름
        logoImage.contentMode = .scaleAspectFit // 비율 유지하며 축소/확대
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        return logoImage
    }()
    
    // 제목과 날짜 UI 추가
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 밑줄 추가
    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray // 밑줄 색상
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 댓글 컨테이너
    let commentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var receivedId: String? // 전달받은 ID를 저장할 변수
    var postData: [String: Any]? // 가져온 데이터를 저장할 변수
    var comments: [[String: Any]] = [] // 댓글 데이터를 저장할 배열
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 전달받은 ID 출력
        if let id = receivedId {
            print("받은 ID: \(id)")
            fetchPostData(withId: id) // 데이터 가져오기
            fetchComments(forPostId: id)
        } else {
            print("ID를 전달받지 못했습니다.")
        }
        
        setupUI()
    }
    
    func fetchPostData(withId id: String) {
        db.collection("posts").document(id).getDocument { (document, error) in
            if let error = error {
                print("Firestore 데이터 가져오기 실패: \(error)")
                return
            }
            
            if let document = document, document.exists {
                self.postData = document.data() // 문서 데이터 저장
//                print("가져온 데이터: \(self.postData ?? [:])")
                DispatchQueue.main.async {
                    self.updateUI()
                }
            } else {
                print("문서를 찾을 수 없습니다.")
            }
        }
    }
    
    func fetchComments(forPostId postId: String) {
        db.collection("comments")
            .whereField("postId", isEqualTo: postId) // postId가 receivedId와 같은 경우만 가져옴
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("댓글 데이터 가져오기 실패: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("댓글 데이터가 없습니다.")
                    return
                }
                
                self.comments = documents.map { $0.data() } // 댓글 데이터를 배열에 저장
//                print("가져온 댓글 데이터: \(self.comments)")
                
                DispatchQueue.main.async {
                    self.updateCommentsUI()
                }
            }
    }
    
    func setupUI() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        view.addSubview(myView)
        let margin: CGFloat = 30
        NSLayoutConstraint.activate([
            myView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            myView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -margin),
            myView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            myView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
        ])
        
        myView.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: myView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        // 제목 추가
        myView.addSubview(titleLabel)
        
        // 날짜 추가
        myView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            // 제목 라벨 제약 조건
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateLabel.leadingAnchor, constant: -10),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: myView.widthAnchor, multiplier: 0.6), // 제목 최대 너비 제한

            // 날짜 라벨 제약 조건
            dateLabel.lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor), // 기준선 정렬
            dateLabel.trailingAnchor.constraint(equalTo: myView.trailingAnchor, constant: -20),
            dateLabel.widthAnchor.constraint(equalToConstant: 80) // 날짜 라벨 너비 고정
        ])
        
        // Hugging Priority 및 Compression Resistance Priority 설정 (별도로 호출)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        // 밑줄 추가
        myView.addSubview(underlineView)
        NSLayoutConstraint.activate([
            underlineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10), // 제목 아래
            underlineView.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: 20), // 좌측 정렬
            underlineView.trailingAnchor.constraint(equalTo: myView.trailingAnchor, constant: -20), // 우측 정렬
            underlineView.heightAnchor.constraint(equalToConstant: 1) // 높이 1pt
        ])
        
        
    }
    
    // 가져온 데이터를 UI에 반영
    func updateUI() {
        guard let postData = postData else { return }
//        print("UI 업데이트 중 데이터: \(postData)")
        
        // 예: UI 요소 업데이트
        
        if let title = postData["title"] as? String {
            titleLabel.text = title
        }
        
        // 날짜 설정
        if let createdAt = postData["createdAt"] as? String {
            dateLabel.text = createdAt
        }
    }
    func updateCommentsUI() {
        // 기존 댓글 뷰 제거
        commentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if comments.isEmpty {
            // 댓글이 없을 경우 "작성된 댓글이 없습니다" 메시지를 추가
            let emptyLabel = UILabel()
            emptyLabel.text = "작성된 댓글이 없습니다."
            emptyLabel.font = UIFont.systemFont(ofSize: 16)
            emptyLabel.textColor = .lightGray
            emptyLabel.textAlignment = .center
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            
            commentsStackView.addArrangedSubview(emptyLabel)
        } else {
            // 댓글이 있는 경우 댓글 뷰 추가
            for comment in comments {
                guard let content = comment["comment"] as? String, let name = comment["name"] as? String else { continue }
                
                let commentView = createCommentView(name: name, content: content)
                commentsStackView.addArrangedSubview(commentView)
            }
        }
        
        // 댓글 스택뷰를 myView에 추가
        if commentsStackView.superview == nil {
            myView.addSubview(commentsStackView)
            NSLayoutConstraint.activate([
                commentsStackView.topAnchor.constraint(equalTo: underlineView.bottomAnchor, constant: 20),
                commentsStackView.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: 20),
                commentsStackView.trailingAnchor.constraint(equalTo: myView.trailingAnchor, constant: -20),
                commentsStackView.bottomAnchor.constraint(lessThanOrEqualTo: myView.bottomAnchor, constant: -20) // 아래 여백
            ])
        }
    }
    // 댓글 뷰 생성 함수
    func createCommentView(name: String, content: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let bubbleView = UIView()
        bubbleView.backgroundColor = UIColor(hex: "#F8F8F8")
        bubbleView.layer.cornerRadius = 10
        bubbleView.translatesAutoresizingMaskIntoConstraints = false

        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let contentLabel = UILabel()
        contentLabel.text = content
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = .black
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add labels to bubbleView
        bubbleView.addSubview(nameLabel)
        bubbleView.addSubview(contentLabel)
        containerView.addSubview(bubbleView)

        NSLayoutConstraint.activate([
            // Bubble view constraints
            bubbleView.topAnchor.constraint(equalTo: containerView.topAnchor),
            bubbleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bubbleView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bubbleView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            // Name label constraints
            nameLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -10),

            // Content label constraints
            contentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            contentLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10),
            contentLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -10),
            contentLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10)
        ])

        return containerView
    }
}
