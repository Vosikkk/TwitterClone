//
//  ButtonFactory.swift
//  TwitterClone
//
//  Created by Саша Восколович on 27.10.2023.
//

import UIKit

struct ColorConstants {
    static let colorButton = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
    static let colorView = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
}

protocol ButtonFactoryProtocol {
    func createMainButton(with name: String, fontSize: CGFloat) -> UIButton
}

final class ButtonFactory: ButtonFactoryProtocol {
    
    func createMainButton(with name: String, fontSize: CGFloat) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(name, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .bold)
        button.backgroundColor = ColorConstants.colorButton
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.isEnabled = false
        return button
    }
}

