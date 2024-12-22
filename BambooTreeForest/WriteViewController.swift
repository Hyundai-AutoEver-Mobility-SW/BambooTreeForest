//
//  WriteViewController.swift
//  BambooTreeForest
//
//  Created by 정한얼 on 12/19/24.
//

import UIKit
import FirebaseFirestore

class WriteViewController: UIViewController {
    // MARK: - Properties
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "제목을 입력해주세요."
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.borderStyle = .none
        textField.returnKeyType = .done
        return textField
    }()
    
    private let titleUnderlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.textColor = .lightGray
        // 테두리 제거
        textView.layer.borderWidth = 0
        return textView
    }()
    
    private let characterCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.spacing = 4
        return stackView
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.font = UIFont(name: "Kodchasan-Regular", size: 14)
        label.textAlignment = .right
        return label
    }()
    
    private let maxCharacterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "/400"
        label.font = UIFont(name: "Kodchasan-Regular", size: 14)
        return label
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("글 작성하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(red: 0.067, green: 0.11, blue: 0.196, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add background view
        let backgroundView = BackgroundView(frame: view.bounds)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        // Add content view
        view.addSubview(contentView)
        
        // Add subviews to content view
        contentView.addSubview(titleTextField)
        contentView.addSubview(titleUnderlineView)
        contentView.addSubview(contentTextView)
        contentView.addSubview(characterCountStackView)
        contentView.addSubview(submitButton)
        
        // Add labels to stack view
        characterCountStackView.addArrangedSubview(characterCountLabel)
        characterCountStackView.addArrangedSubview(maxCharacterLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Background view
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            
            // Title text field
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Title underline view
            titleUnderlineView.heightAnchor.constraint(equalToConstant: 1), // 구분선 높이
            titleUnderlineView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8), // 제목과의 간격
            titleUnderlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16), // 왼쪽 마진
            titleUnderlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16), // 오른쪽 마진
            
            // Content text view
            contentTextView.topAnchor.constraint(equalTo: titleUnderlineView.bottomAnchor, constant: 8),
            contentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Character count stack view
            characterCountStackView.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 8),
            characterCountStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Submit button
            submitButton.topAnchor.constraint(equalTo: characterCountStackView.bottomAnchor, constant: 16),
            submitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            submitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            submitButton.heightAnchor.constraint(equalToConstant: 60),
            
            contentTextView.bottomAnchor.constraint(equalTo: characterCountStackView.topAnchor, constant: -8)
        ])
        
        // Setup initial state
        contentTextView.text = "내용을 입력하세요"
        contentTextView.textColor = .lightGray
    }
    
    private func setupDelegates() {
        titleTextField.delegate = self
        contentTextView.delegate = self
    }
    
    private func setupActions() {
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
    }
    
    @objc private func handleSubmit() {
        guard let title = titleTextField.text, !title.isEmpty,
              let content = contentTextView.text, content != "내용을 입력하세요" else {
            // Show alert for empty fields
            let alert = UIAlertController(title: "알림",
                                        message: "제목과 내용을 모두 입력해주세요.",
                                        preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Get current date string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let currentDate = dateFormatter.string(from: Date())
        
        // Create post data
        let postData: [String: Any] = [
            "title": title,
            "content": content,
            "createdAt": currentDate,
            "commentCount": 0,
            "isLiked": false
        ]
        
        // Save to Firestore
        let db = Firestore.firestore()
        db.collection("posts").addDocument(data: postData) { [weak self] error in
            if let error = error {
                print("Error adding document: \(error)")
                // Show error alert
                let alert = UIAlertController(title: "오류",
                                            message: "게시글 등록에 실패했습니다.",
                                            preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: true)
            } else {
                // Success - dismiss view controller
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension WriteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate
extension WriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력하세요"
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        characterCountLabel.text = "\(count)"
    }
}
