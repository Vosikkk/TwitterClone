//
//  ButtonFactory.swift
//  TwitterClone
//
//  Created by Саша Восколович on 27.10.2023.
//

import UIKit


protocol ButtonFactoryProtocol {
    func createEnterButton(with name: String) -> UIButton
}

final class ButtonFactory: ButtonFactoryProtocol {
    func createEnterButton(with name: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(name, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.isEnabled = false
        return button
    }
}
