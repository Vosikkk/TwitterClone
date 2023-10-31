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


extension CGRect {
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}
extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

extension UIColor {
    
    static let tweeterBlueColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
}
