//
//  OnboardingViewController.swift
//  TwitterClone
//
//  Created by Саша Восколович on 15.10.2023.
//

import UIKit

class OnboardingViewController: UIViewController {

   // MARK: - Properties
    
    private let commonFactory: GeneralFactory
    
    private let authenticationViewModel: AuthenticationViewModel
    
    lazy var createAccountButton: UIButton = {
        return commonFactory.buttonFactory.createMainFormButton(
            with: TitleConstants.createAccountButtonTitle,
            fontSize: FontConstants.createAccountButtonFontSize)
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = commonFactory.labelFactory.createLabel(
            with: TitleConstants.welcomeLabelTitle,
            textStyle: .label,
            fontSize: .systemFont(ofSize: FontConstants.welcomeLabelFontSize, weight: .heavy))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var promptLabel: UILabel = {
        let label = commonFactory.labelFactory.createLabel(
            with: TitleConstants.promptLabelTitle,
            textStyle: .secondaryLabel,
            fontSize: .systemFont(ofSize: FontConstants.promptLabelFontSize, weight: .regular))
        label.textColor = .gray
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(TitleConstants.loginButtonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: FontConstants.promptLabelFontSize)
        button.tintColor = ColorConstants.colorButton
        return button
    }()
    
    
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(welcomeLabel)
        view.addSubview(createAccountButton)
        view.addSubview(promptLabel)
        view.addSubview(loginButton)
       
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        
        
        configureConstraints()
    }
    
   
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
        print("OnboardingViewController деініціалізований")
    }
    
    
    // MARK: - @objc Methods
    
    @objc private func didTapLogin() {
        let vc = LoginViewController(
            authenticationViewModel: authenticationViewModel,
            commonFactory: commonFactory)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapCreateAccount() {
        let vc = RegisterViewController(
            authenticationViewModel: authenticationViewModel,
            commonFactory: commonFactory)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // MARK: - Func
   
    private func configureConstraints() {
        let welcomeLabelConstraints = [
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.welcomeLabelOffset),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: LayoutConstants.welcomeLabelTrailingOffset),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        let createAccountButtonConstraints = [
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           
            createAccountButton.topAnchor.constraint(
                equalTo: welcomeLabel.bottomAnchor, constant: LayoutConstants.createAccountButtonTopOffset),
            
            createAccountButton.widthAnchor.constraint(
                equalTo: welcomeLabel.widthAnchor, constant: LayoutConstants.createAccountButtonWidthOffset),
            
            createAccountButton.heightAnchor.constraint(equalToConstant: SizeConstants.createAccountButtonHeight)
        ]
        
        let promptLabelConstraints = [
            promptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.promptLabelOffset),
            promptLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: LayoutConstants.negativePromptLabelOffset)
        ]
        
        let loginButtonConstraints = [
            loginButton.centerYAnchor.constraint(equalTo: promptLabel.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: promptLabel.trailingAnchor, constant: LayoutConstants.loginButtonOffset)
        ]
        NSLayoutConstraint.activate(loginButtonConstraints)
        NSLayoutConstraint.activate(promptLabelConstraints)
        NSLayoutConstraint.activate(createAccountButtonConstraints)
        NSLayoutConstraint.activate(welcomeLabelConstraints)
    }
    
    // MARK: - NESTED TYPE
    
    private struct LayoutConstants {
        static let welcomeLabelOffset: CGFloat = 20
        static let welcomeLabelTrailingOffset: CGFloat = -20
        static let createAccountButtonTopOffset: CGFloat = 20
        static let createAccountButtonWidthOffset: CGFloat = -20
        static let promptLabelOffset: CGFloat = 20
        static let negativePromptLabelOffset: CGFloat = -60
        static let loginButtonOffset: CGFloat = 10
    }
    
    private struct SizeConstants {
        static let createAccountButtonHeight: CGFloat = 60
    }

    private struct FontConstants {
        static let createAccountButtonFontSize: CGFloat = 24
        static let promptLabelFontSize: CGFloat = 14
        static let welcomeLabelFontSize: CGFloat = 32
       
    }
    
    private struct TitleConstants {
        static let loginButtonTitle = "Login"
        static let promptLabelTitle = "Have an account already?"
        static let welcomeLabelTitle = "See what's happening in the world right now"
        static let createAccountButtonTitle = "Create account"
    }
}
