//
//  TweetTableViewCell.swift
//  TwitterClone
//
//  Created by Саша Восколович on 06.10.2023.
//

import UIKit

protocol TweetTableViewCellDelegate: AnyObject {
    func tweetTableViewCellDidTapReply(what cell: TweetTableViewCell)
    func tweetTableViewCellDidTapRetweet()
    func tweetTableViewCellDidTapLike()
    func tweetTableViewCellDidTapShare()
}



class TweetTableViewCell: UITableViewCell {

    
    // MARK: - Properties
    
    static let identifier = "TweetTableViewCell"
    
    weak var delegate: TweetTableViewCellDelegate?
    
    private var profileAvatar = ProfileCustomUIView()
    
    
    private let displayNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sasha Voskolovych"
        label.font = .systemFont(ofSize: FontSizeConstants.displayNameLabelFontSize, weight: .bold)
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@Vosik"
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: FontSizeConstants.userNameLabelFontSize, weight: .regular)
        return label
    }()
    
    private let tweetTextContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This my Mockup tweet. It is going to take multiple lines. I believe some more text is enough but let some more anyway .. and cheers youtube "
        label.numberOfLines = 0
        
        return label
    }()
    
    private let replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: TitleConstants.replyButtonName), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    private let retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: TitleConstants.retweetButtonName), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: TitleConstants.likeButtonName), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: TitleConstants.shareButton), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
   
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(displayNameLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(tweetTextContentLabel)
        contentView.addSubview(retweetButton)
        contentView.addSubview(replyButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(profileAvatar)
        
        configureConstraints()
        configureButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        profileAvatar.frame = CGRect(x: PositionConstants.avatarX,
                                     y: PositionConstants.avatarY,
                                     width: SizeConstants.avatarWidth,
                                     height: SizeConstants.avatarHeight)
    }
    
    
    // MARK: - @objc Methods
    
    @objc private func didTapReply() {
        delegate?.tweetTableViewCellDidTapReply(what: self)
    }
    @objc private func didTapRetweet() {
        delegate?.tweetTableViewCellDidTapRetweet()
    }
    @objc private func didTapLike() {
        delegate?.tweetTableViewCellDidTapLike()
    }
    @objc private func didTapSahre() {
        delegate?.tweetTableViewCellDidTapShare()
    }
    
    
    // MARK: - Func
    
    private func configureButtons() {
        replyButton.addTarget(self, action: #selector(didTapReply), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(didTapRetweet), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapSahre), for: .touchUpInside)
    }
    
    
    private func configureConstraints() {
        
        let displayNameLabelConstraints = [
            displayNameLabel.leadingAnchor.constraint(
                equalTo: profileAvatar.trailingAnchor,
                constant: LayoutConstants.displayNameLabelLeadingOffset),
            
            displayNameLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: LayoutConstants.displayNameLabelTopOffset),
        ]
        
        let userNameLabelConsytraints = [
            userNameLabel.leadingAnchor.constraint(
                equalTo: displayNameLabel.trailingAnchor,
                constant: LayoutConstants.userNameLabelLeadingOffset),
            
            userNameLabel.centerYAnchor.constraint(equalTo: displayNameLabel.centerYAnchor)
        ]
        
        let tweetTextContentLabelConstraints = [
            tweetTextContentLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            
            tweetTextContentLabel.topAnchor.constraint(
                equalTo: displayNameLabel.bottomAnchor,
                constant: LayoutConstants.tweetTextContentLabelTopOffset),
            
            tweetTextContentLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: LayoutConstants.tweetTextContentLabelTrailingOffset),
           // tweetTextContentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ]
        
        let replyButtonConstraints = [
            replyButton.leadingAnchor.constraint(equalTo: tweetTextContentLabel.leadingAnchor),
            
            replyButton.topAnchor.constraint(
                equalTo: tweetTextContentLabel.bottomAnchor,
                constant: LayoutConstants.replyButtonTopOffset),
            
            replyButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: LayoutConstants.replyButtonBottomOffset)
        ]
        
        let retweetButtonConstraints = [
            retweetButton.leadingAnchor.constraint(equalTo: replyButton.trailingAnchor, constant: LayoutConstants.actionSpacing),
            retweetButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ]
        
        
        let likeButtonConstraints = [
            likeButton.leadingAnchor.constraint(equalTo: retweetButton.trailingAnchor, constant: LayoutConstants.actionSpacing),
            likeButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ]
        
        let shareButtonConstraints = [
            shareButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: LayoutConstants.actionSpacing),
            shareButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(displayNameLabelConstraints)
        NSLayoutConstraint.activate(userNameLabelConsytraints)
        NSLayoutConstraint.activate(tweetTextContentLabelConstraints)
        NSLayoutConstraint.activate(shareButtonConstraints)
        NSLayoutConstraint.activate(likeButtonConstraints)
        NSLayoutConstraint.activate(retweetButtonConstraints)
        NSLayoutConstraint.activate(replyButtonConstraints)
    }
    
    
    // MARK: - Nested Type
    
    private struct SizeConstants {
        static let avatarWidth: CGFloat = 60
        static let avatarHeight: CGFloat = 60
    }
    
    private struct PositionConstants {
        static let avatarX: CGFloat = 0
        static let avatarY: CGFloat = 22
    }
    
    private struct TitleConstants {
        static let replyButtonName = "replyIcon"
        static let retweetButtonName = "retweetIcon"
        static let likeButtonName = "likeIcon"
        static let shareButton = "shareIcon"
    }
    
    private struct FontSizeConstants {
        static let displayNameLabelFontSize: CGFloat = 18
        static let userNameLabelFontSize: CGFloat = 16
    }
    
    private struct LayoutConstants {
        static let displayNameLabelLeadingOffset: CGFloat = 20
        static let displayNameLabelTopOffset: CGFloat = 20
        static let userNameLabelLeadingOffset: CGFloat = 10
        static let tweetTextContentLabelTopOffset: CGFloat = 10
        static let tweetTextContentLabelTrailingOffset: CGFloat = -15
        static let replyButtonTopOffset: CGFloat = 15
        static let replyButtonBottomOffset: CGFloat = -15
        static let actionSpacing: CGFloat = 55
    }
}
