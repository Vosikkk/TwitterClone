//
//  TweetComposeViewController.swift
//  TwitterClone
//
//  Created by Саша Восколович on 31.10.2023.
//

import UIKit
import Combine


class TweetComposeViewController: UIViewController {

    
    private var subscriptions: Set<AnyCancellable> = []
    
    private let tweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .tweeterBlueColor
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = SizeConstants.tweetButtonCornerRadius
        button.clipsToBounds = true
        button.isEnabled = false
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .disabled)
        button.widthAnchor.constraint(equalToConstant: SizeConstants.tweetButtonWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: SizeConstants.tweetButtonHeight).isActive = true
        return button
    }()
    
    private let tweetContentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = "What's happening?"
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    var characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "140/140"
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let composeViewModel: TweetComposeViewModel
    
    
    init(composeViewModel: TweetComposeViewModel) {
        self.composeViewModel = composeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Tweet"
        
        tweetContentTextView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapToCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetButton)
        
        view.addSubview(tweetContentTextView)
        view.addSubview(characterCountLabel)
        
        tweetButton.addTarget(self, action: #selector(didTapToTweet), for: .touchUpInside)
        
        configureConstraints()
        bindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        composeViewModel.getUserData()
    }
    
    @objc func didTapToCancel() {
        dismiss(animated: true)
    }
    
    @objc func didTapToTweet() {
        composeViewModel.dispatchTweet()
    }
    
    
    private func bindViews() {
        composeViewModel.$isValideToTweet.sink { [weak self] state in
            self?.tweetButton.isEnabled = state
            
        }
        .store(in: &subscriptions)
        
        composeViewModel.$shouldDismissScreen.sink { [weak self] success in
            if success {
                self?.dismiss(animated: true)
            }
        }.store(in: &subscriptions)
    }
    
    private func configureConstraints() {
        let tweetContentTextViewConstraints = [
            tweetContentTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            tweetContentTextView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: LayoutConstants.tweetContentTextViewLeadingOffset),
            
            tweetContentTextView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: LayoutConstants.tweetContentTextViewTrailingOffset),
            
            tweetContentTextView.bottomAnchor.constraint(
                equalTo: view.keyboardLayoutGuide.topAnchor, constant: LayoutConstants.tweetContentTextViewBottomOffset)
        
        ]
        let characterCountLabelConstraints = [
            characterCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            characterCountLabel.bottomAnchor.constraint(equalTo: tweetContentTextView.bottomAnchor, constant: -5)
        ]
        
        NSLayoutConstraint.activate(characterCountLabelConstraints)
        NSLayoutConstraint.activate(tweetContentTextViewConstraints)
    }
    
    
    private struct SizeConstants {
        static let tweetButtonHeight: CGFloat = 30
        static let tweetButtonWidth: CGFloat = 60
        static let tweetButtonCornerRadius: CGFloat = 15
    }
    
    private struct LayoutConstants {
        static let tweetContentTextViewLeadingOffset: CGFloat = 15
        static let tweetContentTextViewTrailingOffset: CGFloat = -15
        static let tweetContentTextViewBottomOffset: CGFloat = -10
    }
}

extension TweetComposeViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .gray
            textView.text = "What's happening"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        composeViewModel.tweetContent = textView.text
        composeViewModel.validateTweet()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let remainingCharacters = 140 - newText.count
        
        
        characterCountLabel.text = "\(remainingCharacters)/140"
        
        return newText.count <= 140
    }
}
