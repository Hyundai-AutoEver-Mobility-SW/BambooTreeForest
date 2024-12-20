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
        label.font = UIFont(name: "Kodchasan-Regular", size: 16)
        
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
}
