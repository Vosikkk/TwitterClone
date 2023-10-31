//
//  RegisterViewController.swift
//  TwitterClone
//
//  Created by Саша Восколович on 16.10.2023.
//

import UIKit
import Combine


class RegisterViewController: UIViewController, CommonFormView {
    
    
    // MARK: - Properties
    
    private let commonFactory: GeneralFactory
    
    private var authenticationViewModel: AuthenticationViewModel
    
    private var subscriptions: Set<AnyCancellable> = []
    
    lazy var passwordTextField: UITextField = {
         let textField = commonFactory.textFieldFactory.createCommonTextField(with: TitleConstants.passwordTextFieldPlaceholder)
         textField.isSecureTextEntry = true
         return textField
    }()
    
    lazy var emailTextFiled: UITextField = {
        let textField = commonFactory.textFieldFactory.createCommonTextField(with: TitleConstants.emailTextFiledPlaceholder)
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    lazy var actionButton: UIButton = {
        return commonFactory.buttonFactory.createMainFormButton(with: TitleConstants.actionButtonTitle, 
                                                            fontSize: FontSizeConstants.actionButtonFontSize)
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
    
    // MARK: - Controller Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
       
        setupUI(in: view)
        configureConstraints(in: view)
        
        actionButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        view.addGestureRecognizer()
       
        bindViews()
    }
    
    
    // MARK: - @objc Methods
    
    @objc private func didTapRegister() {
        authenticationViewModel.createUser()
    }
    
    @objc func didChangePasswordFiled() {
        authenticationViewModel.password = passwordTextField.text
        authenticationViewModel.validateAuthenticationForm()
    }
    
    
    @objc private func didChangeEmailField() {
        authenticationViewModel.email = emailTextFiled.text
        authenticationViewModel.validateAuthenticationForm()
    }
    
    // MARK: - Func
    
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
    
    
    // MARK: - Nested Type
    
    private struct FontSizeConstants {
        static let actionButtonFontSize: CGFloat = 16
        static let loginLabelFontSize: CGFloat = 32
    }
    
    private struct TitleConstants {
        static let actionButtonTitle = "Create account"
        static let emailTextFiledPlaceholder = "Email"
        static let passwordTextFieldPlaceholder = "Password"
        static let loginLabelTitle = "Create your account"
    }
}
