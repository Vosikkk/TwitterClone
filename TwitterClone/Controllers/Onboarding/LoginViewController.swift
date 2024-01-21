//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by Саша Восколович on 23.10.2023.
//

import UIKit
import Combine

class LoginViewController: UIViewController, CommonFormView {
    
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private let authenticationViewModel: AuthenticationViewModel
    private let commonFactory: GeneralFactory
    
    lazy var actionButton: UIButton = {
        return commonFactory.buttonFactory.createMainFormButton(with: TitleConstants.actionButtonTitle,
                                                            fontSize: FontSizeConstants.actionButtonFontSize)
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = commonFactory.textFieldFactory.createCommonTextField(with: TitleConstants.emailTextFiledPlaceholder)
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = commonFactory.textFieldFactory.createCommonTextField(with: TitleConstants.passwordTextFieldPlaceholder)
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        return textField
    }()
    
    var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = TitleConstants.loginLabelTitle
        label.font = .systemFont(ofSize: FontSizeConstants.loginLabelFontSize, weight: .bold)
        return label
    }()
    
    
    // MARK: - Init
    
    init(authenticationViewModel: AuthenticationViewModel, commonFactory: GeneralFactory) {
        self.authenticationViewModel = authenticationViewModel
        self.commonFactory = commonFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        authenticationViewModel.error = nil
        print("RegisterViewController деініціалізований")
    }
    
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI(in: view)
        configureConstraints(in: view)
        actionButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        passwordTextField.delegate = self
        emailTextField.delegate = self
        bindViews()
    }
    
    
    // MARK: - @objc Methods
    
    @objc private func didTapToDismiss() {
        view.endEditing(true)
    }
    
    @objc private func didTapLogin() {
        authenticationViewModel.loginUser()
    }
    
    @objc func didChangePasswordFiled() {
        authenticationViewModel.password = passwordTextField.text
        authenticationViewModel.validateAuthenticationForm()
    }
    
    @objc func didChangeEmailField() {
        authenticationViewModel.email = emailTextField.text
        authenticationViewModel.validateAuthenticationForm()
    }
    
    
    // MARK: - Func
    
    func bindViews() {
        emailTextField.addTarget(self, action: #selector(didChangeEmailField), for: .editingChanged)
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
    
    // MARK: - Nested Type
    private struct FontSizeConstants {
        static let actionButtonFontSize: CGFloat = 16
        static let loginLabelFontSize: CGFloat = 32
    }
    
    private struct TitleConstants {
        static let actionButtonTitle = "Create account"
        static let emailTextFiledPlaceholder = "Email"
        static let passwordTextFieldPlaceholder = "Password"
        static let loginLabelTitle = "Login to your account"
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === emailTextField {
            return !string.contains(" ")
        } else {
            return true
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            guard let email = emailTextField.text,
                  let password = passwordTextField.text else { return false }
            passwordTextField.resignFirstResponder()
        }
        return false 
    }
}
