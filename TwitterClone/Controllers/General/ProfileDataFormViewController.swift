//
//  ProfileDataFormViewController.swift
//  TwitterClone
//
//  Created by Саша Восколович on 24.10.2023.
//

import UIKit
import PhotosUI

class ProfileDataFormViewController: UIViewController {

    // MARK: - Properties
    
    private let commonFactory: GeneralFactory
    
    private lazy var submitButton: UIButton = {
        return commonFactory.buttonFactory.createMainFormButton(
            with: "Submit",
            fontSize: FontSizeConstants.submitButtonFontSize)
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    
    
    private lazy var hintLabel: UILabel = {
        return commonFactory.labelFactory.createLabel(
            with: "Fill in your data",
            textStyle: .label,
            fontSize: .systemFont(ofSize: FontSizeConstants.hintLabelFontSize, weight: .bold))
    }()
    
    private lazy var dispalyNameTextField: UITextField = {
        return commonFactory.textFieldFactory.createRegisterTextField(
            with: NSAttributedString(string: "Display Name",
                                     attributes: [.foregroundColor: UIColor.gray]))
    }()
    private lazy var userNameTextField: UITextField = {
        return commonFactory.textFieldFactory.createRegisterTextField(
            with: NSAttributedString(string: "Username",
                                     attributes: [.foregroundColor: UIColor.gray]))
    }()
    
    private var avatarPlaceholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.backgroundColor = .lightGray
        imageView.image = UIImage(systemName: "camera.fill")
        imageView.tintColor = .gray
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let bioTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .secondarySystemFill
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = "Tell the world about yourself"
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: FontSizeConstants.bioTextViewFontSize)
        return textView
    }()
    
   
    
    // MARK: - Init
    
    init(commonFactory: GeneralFactory) {
        self.commonFactory = commonFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.addSubview(hintLabel)
        scrollView.addSubview(dispalyNameTextField)
        scrollView.addSubview(userNameTextField)
        scrollView.addSubview(avatarPlaceholderImageView)
        scrollView.addSubview(bioTextView)
        scrollView.addSubview(submitButton)
        
        dispalyNameTextField.delegate = self
        userNameTextField.delegate = self
        bioTextView.delegate = self
        
        isModalInPresentation = true
        
        view.addGestureRecognizer()
        
       
        avatarPlaceholderImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToUpload)))
        configureConstraints()
    }
    
    @objc private func didTapToUpload() {
       
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - Func
    
    private func configureConstraints() {

        let scrollViewConstraints = [
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let hintLabelConstraints = [
            hintLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            hintLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: LayoutConstants.hintLabelTopOffset)
        ]
        
        let dispalyNameTextFieldConstraints = [
            dispalyNameTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: LayoutConstants.dispalyNameTextFieldLeadingOffset),
           
            dispalyNameTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: LayoutConstants.dispalyNameTextFieldTrailingOffset),
            
            dispalyNameTextField.topAnchor.constraint(
                equalTo: avatarPlaceholderImageView.bottomAnchor, constant: LayoutConstants.dispalyNameTextFieldTopOffset),
           
            dispalyNameTextField.heightAnchor.constraint(equalToConstant: SizeConstants.dispalyNameTextFieldHeight)
        ]
        
        let userNameTextFieldConstraints = [
            userNameTextField.leadingAnchor.constraint(equalTo: dispalyNameTextField.leadingAnchor),
            userNameTextField.trailingAnchor.constraint(equalTo: dispalyNameTextField.trailingAnchor),
            
            userNameTextField.topAnchor.constraint(
                equalTo: dispalyNameTextField.bottomAnchor, constant: LayoutConstants.userNameTextFieldTopOffset),
            
            userNameTextField.heightAnchor.constraint(equalToConstant: SizeConstants.userNameTextFieldHeight)
        ]
        
        let avatarPlaceholderImageViewConstraints = [
            avatarPlaceholderImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            avatarPlaceholderImageView.heightAnchor.constraint(equalToConstant: SizeConstants.avatarPlaceholderImageViewHeight),
            avatarPlaceholderImageView.widthAnchor.constraint(equalToConstant: SizeConstants.avatarPlaceholderImageViewWidth),
            avatarPlaceholderImageView.topAnchor.constraint(
                equalTo: hintLabel.bottomAnchor, constant: LayoutConstants.avatarPlaceholderImageViewTopOffset)
        ]
        
        let bioTextViewonstraints = [
            bioTextView.leadingAnchor.constraint(equalTo: dispalyNameTextField.leadingAnchor),
            bioTextView.trailingAnchor.constraint(equalTo: dispalyNameTextField.trailingAnchor),
            bioTextView.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: LayoutConstants.bioTextViewTopOffset),
            bioTextView.heightAnchor.constraint(equalToConstant: SizeConstants.bioTextViewHeight)
        ]
        
        let submitButtonConstraints = [
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.submitButtonLeadingOffset),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: LayoutConstants.submitButtonTrailingOffset),
            submitButton.heightAnchor.constraint(equalToConstant: SizeConstants.submitButtonHeight),
            submitButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: LayoutConstants.submitButtonBottomOffset)
        ]
        
        
        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(hintLabelConstraints)
        NSLayoutConstraint.activate(avatarPlaceholderImageViewConstraints)
        NSLayoutConstraint.activate(userNameTextFieldConstraints)
        NSLayoutConstraint.activate(dispalyNameTextFieldConstraints)
        NSLayoutConstraint.activate(bioTextViewonstraints)
        NSLayoutConstraint.activate(submitButtonConstraints)
    }
    
    private struct FontSizeConstants {
        static let submitButtonFontSize: CGFloat = 16
        static let hintLabelFontSize: CGFloat = 32
        static let bioTextViewFontSize: CGFloat = 16
    }
    
    
    private struct LayoutConstants {
        static let hintLabelTopOffset: CGFloat = 30
        static let dispalyNameTextFieldLeadingOffset: CGFloat = 20
        static let dispalyNameTextFieldTrailingOffset: CGFloat = -20
        static let dispalyNameTextFieldTopOffset: CGFloat = 40
        static let userNameTextFieldTopOffset: CGFloat = 20
        static let avatarPlaceholderImageViewTopOffset: CGFloat = 30
        static let bioTextViewTopOffset: CGFloat = 20
        static let submitButtonLeadingOffset: CGFloat = 20
        static let submitButtonTrailingOffset: CGFloat = -20
        static let submitButtonBottomOffset: CGFloat = -20
        static let scrollViewEditinYOffset: CGFloat = 100
        static let scrollViewDefaultYOffset: CGFloat = 0
        static let scrollViewDefaultXOffset: CGFloat = 0
    }
    
    private struct SizeConstants {
        static let dispalyNameTextFieldHeight: CGFloat = 50
        static let userNameTextFieldHeight: CGFloat = 50
        static let avatarPlaceholderImageViewHeight: CGFloat = 120
        static let avatarPlaceholderImageViewWidth: CGFloat = 120
        static let bioTextViewHeight: CGFloat = 150
        static let submitButtonHeight: CGFloat = 50
    }
}


// MARK: - UITextViewDelegate

extension ProfileDataFormViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(
            CGPoint(x: LayoutConstants.scrollViewDefaultXOffset, y: textView.frame.origin.y - LayoutConstants.scrollViewEditinYOffset),              animated: true)
        if textView.textColor == .gray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(
            CGPoint(x: LayoutConstants.scrollViewDefaultXOffset, y: LayoutConstants.scrollViewDefaultYOffset), animated: true)
        
        if textView.text.isEmpty {
            textView.textColor = .gray
            textView.text = "Tell the world about yourself"
        }
    }
}

extension ProfileDataFormViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(
            CGPoint(x: LayoutConstants.scrollViewDefaultXOffset, y: textField.frame.origin.y - LayoutConstants.scrollViewEditinYOffset),             animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(
            CGPoint(x: LayoutConstants.scrollViewDefaultXOffset, y: LayoutConstants.scrollViewDefaultYOffset), animated: true)
    }
}

extension ProfileDataFormViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.avatarPlaceholderImageView.image = image
                    }
                }
            }
        }
    }
}
