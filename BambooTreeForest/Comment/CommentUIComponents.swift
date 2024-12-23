//
//  CommentUIComponents.swift
//  BambooTreeForest
//
//  Created by softourr on 12/20/24.
//

import UIKit

class CommentUIComponents {
    static func createMyView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#111C32")
        view.layer.cornerRadius = 30
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    static func createScrollView(with contentView: UIView) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        return scrollView
    }
    
    static func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Kodchasan-Light", size: 20)
        // label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    static func createDateLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Kodchasan-Light", size: 14)
        // label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    static func createUnderlineView() -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    static func createCommentsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    static func createDeleteButton(target: Any?, action: Selector) -> UIButton {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
            button.tintColor = .black
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(target, action: action, for: .touchUpInside)
            return button
        }
}
