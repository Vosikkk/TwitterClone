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
