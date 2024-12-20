//
//  LabelHelpers.swift
//  BambooTreeForest
//
//  Created by softourr on 12/20/24.
//

import UIKit

extension UIView {
    // MARK: - Label Creation Helpers
    
    /// Create a title label with a specific style.
    func createTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.78
        
        label.attributedText = NSMutableAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.font: UIFont(name: "Kodchasan-Regular", size: 24) ?? UIFont.systemFont(ofSize: 24),
                NSAttributedString.Key.kern: 5.6,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        )
        return label
    }
    
    /// Create a date label with a specific style.
    func createDateLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "Kodchasan-Light", size: 13)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.78
        
        label.attributedText = NSMutableAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        )
        return label
    }
    
    /// Create a content label with a specific style.
    func createContentLabel(text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "Kodchasan-Regular", size: 15)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.04 // Line height 설정
        
        label.attributedText = NSMutableAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
            ]
        )
        
        return label
    }
    func createActionButton(commentCount: Int, isLiked: Bool, onCommentButtonTapped: @escaping () -> Void, onHeartButtonClicked: @escaping (Bool) -> Void) -> UIView {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.backgroundColor = UIColor(red: 0.067, green: 0.11, blue: 0.196, alpha: 1).cgColor
        button.layer.cornerRadius = 15

        // 댓글 라벨
        let commentLabel = UILabel()
        commentLabel.text = "댓글 \(commentCount)"
        commentLabel.textColor = .white
        commentLabel.font = UIFont.systemFont(ofSize: 14)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false

        // 하트 아이콘
        let heartButton = UIButton()
        let heartImage = UIImage(systemName: isLiked ? "heart.fill" : "heart")
        heartButton.setImage(heartImage, for: .normal)
        heartButton.tintColor = .white
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 하트 버튼 클릭 이벤트
        var currentLikedState = isLiked // 현재 상태를 로컬에서 관리
        heartButton.addAction(UIAction(handler: { _ in
            currentLikedState.toggle() // 상태 반전
            heartButton.setImage(UIImage(systemName: currentLikedState ? "heart.fill" : "heart"), for: .normal) // UI 업데이트
            onHeartButtonClicked(currentLikedState) // 새로운 상태 전달
        }), for: .touchUpInside)
        
        // 댓글 버튼 클릭 이벤트 추가
        button.addAction(UIAction(handler: { _ in
            onCommentButtonTapped() // 뷰 컨트롤러에서 처리하도록 클로저 호출
        }), for: .touchUpInside)
        
        // 댓글과 하트 추가
        button.addSubview(commentLabel)
        button.addSubview(heartButton)
        

        NSLayoutConstraint.activate([
            // 댓글 라벨
            commentLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            commentLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10),

            // 하트 아이콘
            heartButton.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            heartButton.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10),
            heartButton.widthAnchor.constraint(equalToConstant: 24), // 아이콘 크기
            heartButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        return button
    }
}

