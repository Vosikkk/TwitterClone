//
//  CommonFormController.swift
//  TwitterClone
//
//  Created by Саша Восколович on 23.10.2023.
//

import Foundation
import UIKit

protocol CommonFormView {
    
    var loginLabel: UILabel { get set }
    var emailTextField: UITextField { get set }
    var passwordTextField: UITextField { get set }
    var actionButton: UIButton { get set }
    
    func configureConstraints(in view: UIView)
    func setupUI(in view: UIView)
    
    func presentAlert(with error: String, on controller: UIViewController)
}


extension CommonFormView {
    
    func configureConstraints(in view: UIView) {
        let loginTitleLabelConstraints = [
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        ]
        
        let emailTextFieldConstraints = [
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 20),
            emailTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let passwordTextFieldConstraints = [
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let loginButtonConstraints = [
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            actionButton.widthAnchor.constraint(equalToConstant: 180),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        
        NSLayoutConstraint.activate(loginButtonConstraints)
        NSLayoutConstraint.activate(passwordTextFieldConstraints)
        NSLayoutConstraint.activate(emailTextFieldConstraints)
        NSLayoutConstraint.activate(loginTitleLabelConstraints)
    }
   
    func setupUI(in view: UIView) {
        view.addSubview(loginLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(actionButton)
    }
    
    func presentAlert(with error: String, on controller: UIViewController) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okeyButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okeyButton)
        controller.present(alert, animated: true)
    }
}

