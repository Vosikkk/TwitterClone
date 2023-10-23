//
//  RegisterViewController.swift
//  TwitterClone
//
//  Created by Саша Восколович on 16.10.2023.
//

import UIKit
import Combine


class RegisterViewController: UIViewController, CommonForm {
    
    
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
    
    var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create account", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.isEnabled = false
        return button
    }()
    
    
    private var registerViewModel: RegisterViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
    
    init(registerViewModel: RegisterViewModel) {
        self.registerViewModel = registerViewModel
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
       
        bindViewss()
    }
    
    @objc private func didTapToDismiss() {
         view.endEditing(true)
    }
    @objc private func didTapRegister() {
        registerViewModel.createUser()
    }
    
    
    private func bindViewss() {
        emailTextFiled.addTarget(self, action: #selector(didChangeEmailField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangePasswordFiled), for: .editingChanged)
        registerViewModel.$isRegistrationValid.sink { [weak self] validation in
            self?.actionButton.isEnabled = validation
        }
        .store(in: &subscriptions)
        
        registerViewModel.$user.sink { [weak self] user in
            guard user != nil else { return }
          
            guard let vc = self?.navigationController?.viewControllers.first as? OnboardingViewController else { return }
            print(vc)
            vc.dismiss(animated: true)
        }
        .store(in: &subscriptions)
        
    }
    
    deinit {
            print("RegisterViewController деініціалізований")
        }
    
    @objc func didChangePasswordFiled() {
        registerViewModel.password = passwordTextField.text
        registerViewModel.validRigestrationForm()
    }
    
    
    @objc private func didChangeEmailField() {
        registerViewModel.email = emailTextFiled.text
        registerViewModel.validRigestrationForm()
    }
}
