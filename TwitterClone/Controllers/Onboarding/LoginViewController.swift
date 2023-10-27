//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by Саша Восколович on 23.10.2023.
//

import UIKit
import Combine

class LoginViewController: UIViewController, CommonFormView {
    
    private var subscriptions: Set<AnyCancellable> = []
    
   
    
    var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Login to your account"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    var emailTextFiled: UITextField = {
        let textFiled = UITextField()
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [.foregroundColor: UIColor.gray]
        )
        textFiled.keyboardType = .emailAddress
        return textFiled
    }()
    
    var passwordTextField: UITextField = {
        let textFiled = UITextField()
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [.foregroundColor: UIColor.gray]
        )
        textFiled.isSecureTextEntry = true
        return textFiled
    }()
    
    lazy var actionButton: UIButton = {
        return buttonFactory.createEnterButton(with: "Login")
    }()
    
    private let authenticationViewModel: AuthenticationViewModel
    private let buttonFactory: ButtonFactory
    
    init(authenticationViewModel: AuthenticationViewModel, buttonFactory: ButtonFactory) {
        self.authenticationViewModel = authenticationViewModel
        self.buttonFactory = buttonFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
       
        setupUI(in: view)
        configureConstraints(in: view)
        actionButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        
        bindViews()
    }
    
    @objc private func didTapToDismiss() {
         view.endEditing(true)
    }
    @objc private func didTapLogin() {
        authenticationViewModel.loginUser()
    }
    
    
    func bindViews() {
       emailTextFiled.addTarget(self, action: #selector(didChangeEmailField), for: .editingChanged)
       passwordTextField.addTarget(self, action: #selector(didChangePasswordFiled), for: .editingChanged)
       authenticationViewModel.$isAuthenticationValid.sink { [weak self] validation in
           self?.actionButton.isEnabled = validation
       }
       .store(in: &subscriptions)
       
       authenticationViewModel.$user.sink { [weak self] user in
           guard user != nil else { return }
         
           guard let vc = self?.navigationController?.viewControllers.first as? OnboardingViewController else { return }
           print(vc)
           vc.dismiss(animated: true)
       }
       .store(in: &subscriptions)
        
        authenticationViewModel.$error.sink { [weak self] errorString in
            guard let error = errorString else { return }
            if let strongSelf = self {
                strongSelf.presentAlert(with: error, on: strongSelf)
            }
        }
        .store(in: &subscriptions)
   }
   
   deinit {
           authenticationViewModel.error = nil
           print("RegisterViewController деініціалізований")
       }
   
   @objc func didChangePasswordFiled() {
       authenticationViewModel.password = passwordTextField.text
       authenticationViewModel.validateAuthenticationForm()
   }
   
   
   @objc func didChangeEmailField() {
       authenticationViewModel.email = emailTextFiled.text
       authenticationViewModel.validateAuthenticationForm()
   }    
}
