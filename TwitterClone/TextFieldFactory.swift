//
//  TextFieldFactory.swift
//  TwitterClone
//
//  Created by Саша Восколович on 27.10.2023.
//

import UIKit

protocol TextFieldFactoryProtocol {
    func createTextField(with placeholder: String) -> UITextField
}

final class TextFieldFactory: TextFieldFactoryProtocol {
    
    func createTextField(with placeholder: String) -> UITextField {
        let textFiled = UITextField()
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.gray]
        )
        textFiled.keyboardType = .emailAddress
        return textFiled
    }
}
