//
//  WriteViewController.swift
//  BambooTreeForest
//
//  Created by 정한얼 on 12/19/24.
//

import UIKit

class WriteViewController: UIViewController {
    @IBOutlet weak var textViewTitle: UITextField!
    @IBOutlet weak var textViewDesc: UITextView!
    @IBOutlet weak var textLength: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TextField (제목) 설정
        textViewTitle.delegate = self
        textViewTitle.placeholder = "제목을 입력하세요"
        textViewTitle.returnKeyType = .done
        
        // TextView (내용) 설정
        textViewDesc.delegate = self
        textViewDesc.layer.borderColor = UIColor.lightGray.cgColor
        textViewDesc.layer.borderWidth = 1.0
        textViewDesc.layer.cornerRadius = 5.0
        
        // 플레이스홀더처럼 보이게 처리
        textViewDesc.text = "내용을 입력하세요"
        textViewDesc.textColor = .lightGray
        
        // 글자수 표시 라벨 초기화
        textLength.text = "0"
    }
}

// TextField 델리게이트 처리
extension WriteViewController: UITextFieldDelegate {
    // 리턴키 눌렀을 때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// TextView 델리게이트 처리
extension WriteViewController: UITextViewDelegate {
    // TextView 편집 시작할 때
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // TextView 편집 종료할 때
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력하세요"
            textView.textColor = .lightGray
        }
    }
    
    // 텍스트 변경될 때마다 글자수 표시
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        textLength.text = "\(count)"
    }
}
