//
//  BackgroundView.swift
//  BambooTreeForest
//
//  Created by softourr on 12/20/24.
//

import UIKit

class BackgroundView: UIView {
    let imageView: UIImageView = {
        let aImageView = UIImageView()
        aImageView.image = UIImage(named: "Frame")
        aImageView.contentMode = .scaleAspectFill
        aImageView.clipsToBounds = true
        aImageView.translatesAutoresizingMaskIntoConstraints = false
        return aImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
