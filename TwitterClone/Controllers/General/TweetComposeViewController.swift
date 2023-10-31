//
//  TweetComposeViewController.swift
//  TwitterClone
//
//  Created by Саша Восколович on 31.10.2023.
//

import UIKit

class TweetComposeViewController: UIViewController {

    private let tweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .tweeterBlueColor
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = SizeConstants.tweetButtonCornerRadius
        button.clipsToBounds = true
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Tweet"
        
        tweetContentTextView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapToCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetButton)
        
        view.addSubview(tweetContentTextView)
        view.addSubview(characterCountLabel)
        
        configureConstraints()
    }
    
    @objc func didTapToCancel() {
        dismiss(animated: true)
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Обмеження до 140 символів
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let remainingCharacters = 140 - newText.count
        
        // Оновлення лейблу
        characterCountLabel.text = "\(remainingCharacters)/140"
        
        // Перевірка на обмеження
        return newText.count <= 140
    }
}
