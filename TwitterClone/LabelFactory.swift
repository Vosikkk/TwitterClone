//
//  LabelFactory.swift
//  TwitterClone
//
//  Created by Саша Восколович on 28.10.2023.
//

import UIKit



protocol LabelFactoryProtocol {
    func createLabel(with text: String, textColor: UIColor, fontSize: UIFont) -> UILabel
}

class LabelFactory: LabelFactoryProtocol {
    
    func createLabel(with text: String, textColor: UIColor, fontSize: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = fontSize
        label.text = text
        label.textColor = textColor
        return label
    }
}
