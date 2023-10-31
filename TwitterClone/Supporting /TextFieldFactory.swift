//
//  TextFieldFactory.swift
//  TwitterClone
//
//  Created by Саша Восколович on 27.10.2023.
//

import UIKit

protocol TextFieldFactoryProtocol {
    func createCommonTextField(with placeholder: String) -> UITextField
    func createRegisterTextField(with attributedPlaceholder: NSAttributedString) -> UITextField
}

final class TextFieldFactory: TextFieldFactoryProtocol {
    
    func createRegisterTextField(with attributedPlaceholder: NSAttributedString) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        textField.backgroundColor = .secondarySystemFill
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        textField.attributedPlaceholder = attributedPlaceholder
        return textField
    }
    
    
    func createCommonTextField(with placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.gray]
        )
        return textField
    }
}
