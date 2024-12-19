//
//  CommentViewController.swift
//  BambooTreeForest
//
//  Created by 오정환 on 12/19/24.
//

import UIKit

class CommentViewController: UIViewController {

    let imageView: UIImageView = {
        let aImageView = UIImageView()
        // 배경 이미지 설정
        aImageView.image = UIImage(named: "Frame")
        aImageView.contentMode = .scaleAspectFill // 이미지 비율 유지하며 꽉 채우기
        aImageView.clipsToBounds = true // 이미지가 View의 경계를 넘어가지 않도록 설정
        aImageView.translatesAutoresizingMaskIntoConstraints = false
        return aImageView
    }()
    
    let myView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#111C32") // 배경색 설정
        view.layer.cornerRadius = 30 // 모서리 둥글기 설정
        view.layer.borderWidth = 1 // 테두리 두께 설정
        view.layer.borderColor = UIColor.white.cgColor // 테두리 색상 설정
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 초기 설정

        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        view.addSubview(myView)
        let margin: CGFloat = 30 // 마진 값
        NSLayoutConstraint.activate([
            myView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin),
            myView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -margin),
            myView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            myView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
        ])    }
}
