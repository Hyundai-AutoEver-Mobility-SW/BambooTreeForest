//
//  PostBoxView.swift
//  BambooTreeForest
//
//  Created by softourr on 12/20/24.
//

import UIKit

class PostBoxView: UIView {
    // MARK: - Initializer
    init(title: String, date: String, content: String, commentCount: Int, isLiked: Bool) {
        super.init(frame: .zero)
        setupView()
        configureContent(title: title, date: date, content: content, commentCount: commentCount, isLiked: isLiked)
        }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup View
    private func setupView() {
        backgroundColor = .clear // 배경색 제거
        layer.cornerRadius = 30 // 모서리 둥글게
        layer.borderWidth = 1 // 테두리 두께
        layer.borderColor = UIColor.white.cgColor // 테두리 색상

        // 배경 이미지 설정
        if let backgroundImage = UIImage(named: "redBox") {
            layer.contents = backgroundImage.cgImage // CALayer에 이미지 설정
            layer.contentsGravity = .resizeAspectFill // 이미지 크기 비율 유지
            layer.masksToBounds = true // 경계를 넘는 이미지 잘라내기
        }

        translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Configure Content
    private func configureContent(title: String, date: String, content: String, commentCount: Int, isLiked: Bool) {
            let contentContainer = UIView()
            contentContainer.translatesAutoresizingMaskIntoConstraints = false
            addSubview(contentContainer)

            NSLayoutConstraint.activate([
                contentContainer.topAnchor.constraint(equalTo: topAnchor, constant: 30),
                contentContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
                contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
                contentContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
            ])

            // Create labels using helper methods from LabelHelpers.swift
            let titleLabel = createTitleLabel(text: title)
            let dateLabel = createDateLabel(text: date)
            let contentLabel = createContentLabel(text: content)
            let actionButton = createActionButton(commentCount: commentCount, isLiked: isLiked) // 버튼 생성
        
            // 구분선 추가
            let separatorView = UIView()
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            separatorView.backgroundColor = UIColor(red: 0.067, green: 0.11, blue: 0.196, alpha: 0.8)
            separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true // 구분선 높이 1pt

            contentContainer.addSubview(titleLabel)
            contentContainer.addSubview(dateLabel)
            contentContainer.addSubview(separatorView)
            contentContainer.addSubview(contentLabel)
            contentContainer.addSubview(actionButton)

            NSLayoutConstraint.activate([
                // Title Label
                titleLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
                titleLabel.heightAnchor.constraint(equalToConstant: 60),

                // Date Label
                dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
                dateLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
                
                // Separator View (구분선)
                separatorView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
                separatorView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
                separatorView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
                separatorView.heightAnchor.constraint(equalToConstant: 1), // 구분선 높이

                // Content Label
                contentLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
                contentLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
                contentLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
                contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentContainer.bottomAnchor),
                
                // Action Button
                actionButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 0),
                actionButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: 0),
                actionButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: 0),
                actionButton.heightAnchor.constraint(equalToConstant: 43),
            ])
        }
    }
