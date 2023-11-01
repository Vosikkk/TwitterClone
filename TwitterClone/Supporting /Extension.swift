//
//  Extension.swift
//  TwitterClone
//
//  Created by Саша Восколович on 29.10.2023.
//

import UIKit

extension UIView {
    
    func addGestureRecognizer() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
    }
   
    @objc private func didTapToDismiss() {
        self.endEditing(true)
    }
}

extension UIColor {
    static let tweeterBlueColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
}

protocol EmailValidatable {
    func isValidEmail() -> Bool
}

extension String: EmailValidatable {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
