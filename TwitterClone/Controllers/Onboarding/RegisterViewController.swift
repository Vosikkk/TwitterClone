//
//  RegisterViewController.swift
//  TwitterClone
//
//  Created by Саша Восколович on 16.10.2023.
//

import UIKit
import Combine


class RegisterViewController: UIViewController, CommonFormView {
    
    private let buttonFactory: ButtonFactory
    
    
    var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create your account"
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
        return buttonFactory.createEnterButton(with: "Create account")
    }()
    
    
    private var authenticationViewModel: AuthenticationViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
    
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
        
        actionButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
       
        bindViews()
    }
    
    @objc private func didTapToDismiss() {
         view.endEditing(true)
    }
    @objc private func didTapRegister() {
        authenticationViewModel.createUser()
    }
    
    
    private func bindViews() {
        emailTextFiled.addTarget(self, action: #selector(didChangeEmailField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangePasswordFiled), for: .editingChanged)
        authenticationViewModel.$isAuthenticationValid.sink { [weak self] validation in
            self?.actionButton.isEnabled = validation
        }
        .store(in: &subscriptions)
        
        authenticationViewModel.$user.sink { [weak self] user in
            guard user != nil else { return }
          
            guard let vc = self?.navigationController?.viewControllers.first as? OnboardingViewController else { return }
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
    
    
    @objc private func didChangeEmailField() {
        authenticationViewModel.email = emailTextFiled.text
        authenticationViewModel.validateAuthenticationForm()
    }
}
