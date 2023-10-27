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
    private let commonFactory: CommonFactory
    
    lazy var actionButton: UIButton = {
        return commonFactory.buttonFactory.createMainButton(with: TitleConstants.actionButtonTitle,
                                                            fontSize: FontSizeConstants.actionButtonFontSize)
    }()
    
    lazy var emailTextFiled: UITextField = {
        commonFactory.textFieldFactory.createTextField(with: TitleConstants.emailTextFiledPlaceholder)
    }()
    
    lazy var passwordTextField: UITextField = {
        commonFactory.textFieldFactory.createTextField(with: TitleConstants.passwordTextFieldPlaceholder)
    }()
    
    var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = TitleConstants.loginLabelTitle
        label.font = .systemFont(ofSize: FontSizeConstants.loginLabelFontSize, weight: .bold)
        return label
    }()
    
    
    // MARK: - Init
    
    init(authenticationViewModel: AuthenticationViewModel, commonFactory: CommonFactory) {
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
        authenticationViewModel.email = emailTextFiled.text
        authenticationViewModel.validateAuthenticationForm()
    }
    
    
    // MARK: - Func
    
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
