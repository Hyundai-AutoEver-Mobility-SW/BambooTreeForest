//
//  PostBoxView.swift
//  BambooTreeForest
//
//  Created by softourr on 12/20/24.
//

import UIKit

class PostBoxView: UIView {
    // MARK: - Initializer
    init(title: String, description: String) {
        super.init(frame: .zero)
        setupView()
        configureContent(title: title, description: description)
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
    private func configureContent(title: String, description: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        addSubview(descriptionLabel)

        // Add Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
