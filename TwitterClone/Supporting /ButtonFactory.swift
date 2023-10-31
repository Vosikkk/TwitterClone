//
//  ButtonFactory.swift
//  TwitterClone
//
//  Created by Саша Восколович on 27.10.2023.
//

import UIKit

protocol ButtonFactoryProtocol {
    func createMainFormButton(with name: String, fontSize: CGFloat) -> UIButton
    func createProfileViewCellButton(of image: UIImage) -> UIButton
}

final class ButtonFactory: ButtonFactoryProtocol {
    
    func createProfileViewCellButton(of image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor = .systemGray2
        return button
    }
    
    
    func createMainFormButton(with name: String, fontSize: CGFloat) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(name, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .bold)
        button.backgroundColor = .tweeterBlueColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.isEnabled = false
        return button
    }
}

