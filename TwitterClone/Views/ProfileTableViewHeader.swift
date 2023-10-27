//
//  ProfileTableViewHeader.swift
//  TwitterClone
//
//  Created by Саша Восколович on 10.10.2023.
//

import UIKit

class ProfileTableViewHeader: UIView {
    
    private let commonFactory: CommonFactory
    
    private enum SectionTabs: String {
        case posts = "Posts"
        case replies = "Replies"
        case highlights = "HighLights"
        case media = "Media"
        case likes = "Likes"
        
        var index : Int {
            switch self {
            case .posts:
                return 0
            case .replies:
                return 1
            case .highlights:
                return 2
            case .media:
                return 3
            case .likes:
                return 4
            }
        }
    }
    
    private var leadingAnchors: [NSLayoutConstraint] = []
    private var trailingAnchors: [NSLayoutConstraint] = []
    
    
    private let indicators: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorConstants.colorView
        return view
    }()
    
    private var selectedTab: Int = 0 {
        didSet {
            for i in 0..<tabs.count {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
                    self?.sectionStack.arrangedSubviews[i].tintColor = i == self?.selectedTab ? .label : .secondaryLabel
                    self?.leadingAnchors[i].isActive = i == self?.selectedTab ? true : false
                    self?.trailingAnchors[i].isActive = i == self?.selectedTab ? true : false
                    self?.layoutIfNeeded()
                }
            }
        }
    }
    private let tabs: [UIButton] = {
        let titles = ["Posts", "Replies", "HighLights", "Media", "Likes"]
        var buttons: [UIButton] = []
        for title in titles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            button.translatesAutoresizingMaskIntoConstraints = false
            buttons.append(button)
        }
        return buttons
    }()
    
    private lazy var sectionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tabs)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var displayNameLabel: UILabel = {
        return commonFactory.labelFactory.createLabel(
            with: "Sasha",
            textColor: .label,
            fontSize: .systemFont(ofSize: FontSizeConstants.displayNameLabelFontSize, 
                                  weight: FontWeightConstants.displayNameLabelWeight))
    }()
    
    private lazy var userNameLabel: UILabel = {
        return commonFactory.labelFactory.createLabel(
            with: "@vosikk",
            textColor: .secondaryLabel,
            fontSize: .systemFont(ofSize: FontSizeConstants.userNameLabelFontSize, 
                                  weight: FontWeightConstants.userNameLabelWeight))
    }()
    
    private lazy var followersTextLabel: UILabel = {
        return commonFactory.labelFactory.createLabel(
            with: "Followers",
            textColor: .secondaryLabel,
            fontSize: .systemFont(ofSize: FontSizeConstants.followersTextLabelFontSize, 
                                  weight: FontWeightConstants.followersTextLabelWeight))
    }()
    
    private lazy var followersCountLabel: UILabel = {
        return commonFactory.labelFactory.createLabel(
            with: "2M",
            textColor: .label,
            fontSize: .systemFont(ofSize: FontSizeConstants.followersCountLabelFontSize, 
                                  weight: FontWeightConstants.followersCountLabelWeight))
    }()
   
    private lazy var followingTextLabel: UILabel = {
        return commonFactory.labelFactory.createLabel(
            with: "Following",
            textColor: .secondaryLabel,
            fontSize: .systemFont(ofSize: FontSizeConstants.followingTextLabelFontSize, 
                                  weight: FontWeightConstants.followingTextLabelWeight))
    }()
    
    private lazy var followingCountLabel: UILabel = {
        return commonFactory.labelFactory.createLabel(
            with: "215",
            textColor: .label,
            fontSize: .systemFont(ofSize: FontSizeConstants.followingCountLabelFontSize, 
                                  weight: FontWeightConstants.followingCountLabelWeight))
    }()
    
    
    private lazy var joinedDateLabel: UILabel = {
        return commonFactory.labelFactory.createLabel(
            with: "Joined May 2021",
            textColor: .secondaryLabel,
            fontSize: .systemFont(ofSize: FontSizeConstants.joinedDateLabelFontSize, 
                                  weight: FontWeightConstants.joinedDateLabelWeight))
    }()
    
    
    private let joinDateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
        imageView.tintColor = .secondaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private let userBioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.text = "iOS developer"
        label.textColor = .label
        return label
    }()

    
    private let profileHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "Unknown")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(frame: CGRect, commonFactory: CommonFactory) {
        self.commonFactory = commonFactory
        super.init(frame: frame)
        addSubview(profileHeaderImageView)
        addSubview(displayNameLabel)
        addSubview(userNameLabel)
        addSubview(userBioLabel)
        addSubview(joinDateImageView)
        addSubview(joinedDateLabel)
        addSubview(followingCountLabel)
        addSubview(followingTextLabel)
        addSubview(followersCountLabel)
        addSubview(followersTextLabel)
        addSubview(sectionStack)
        addSubview(indicators)
        configureConstraints()
        configureStackButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func configureStackButtons() {
        for (i, button) in tabs.enumerated() {
            button.addTarget(self, action: #selector(didTapTab), for: .touchUpInside)
            button.tintColor = i == selectedTab ? .label : .secondaryLabel
        }
    }
    
    @objc private func didTapTab(_ sender: UIButton) {
        guard let label = sender.titleLabel?.text else { return }
        switch label {
        case ~SectionTabs.posts:
            selectedTab = 0
        case ~SectionTabs.replies:
            selectedTab = 1
        case ~SectionTabs.highlights:
            selectedTab = 2
        case ~SectionTabs.media:
            selectedTab = 3
        case ~SectionTabs.likes:
            selectedTab = 4
        default:
            selectedTab = 0
        }
    }
    
    
    private func configureConstraints() {
        
        fillLayoutForIndicators()
        
        let profileHeaderImageViewConstraints = [
            profileHeaderImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileHeaderImageView.topAnchor.constraint(equalTo: topAnchor),
            profileHeaderImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileHeaderImageView.heightAnchor.constraint(equalToConstant: 150)
        ]
        let displayNameLabelConstraints = [
            displayNameLabel.leadingAnchor.constraint(equalTo: profileHeaderImageView.leadingAnchor, constant: 10),
            displayNameLabel.topAnchor.constraint(equalTo: profileHeaderImageView.bottomAnchor, constant: 60)
        ]
        let userNameLabelConstraints = [
            userNameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            userNameLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 5)
        ]
        let userBioLabelConstraints = [
            userBioLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
           // userBioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            userBioLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20)
        ]
        let joinDateImageViewConstraints = [
            joinDateImageView.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            joinDateImageView.topAnchor.constraint(equalTo: userBioLabel.bottomAnchor, constant: 10)
        ]
        let joinedDateLabelConstraints = [
            joinedDateLabel.leadingAnchor.constraint(equalTo: joinDateImageView.trailingAnchor, constant: 2),
            joinedDateLabel.bottomAnchor.constraint(equalTo: joinDateImageView.bottomAnchor)
        ]
        
        let followingCountLabelConstraints = [
            followingCountLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            followingCountLabel.topAnchor.constraint(equalTo: joinedDateLabel.bottomAnchor, constant: 15)
        ]
                
        let followingTextLabelConstraints = [
            followingTextLabel.leadingAnchor.constraint(equalTo: followingCountLabel.trailingAnchor, constant: 6),
            followingTextLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ]
                
        let followersCountLabelConstraints = [
            followersCountLabel.leadingAnchor.constraint(equalTo: followingTextLabel.trailingAnchor, constant: 6),
            followersCountLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ]
                
        let followersTextLabelConstraints = [
            followersTextLabel.leadingAnchor.constraint(equalTo: followersCountLabel.trailingAnchor, constant: 6),
            followersTextLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ]
        
        let sectionStackConstraints = [
            sectionStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            sectionStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            sectionStack.topAnchor.constraint(equalTo: followingCountLabel.bottomAnchor, constant: 13),
            sectionStack.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        let indicatorsConstraints = [
            leadingAnchors[0],
            trailingAnchors[0],
            indicators.topAnchor.constraint(equalTo: sectionStack.arrangedSubviews[0].bottomAnchor),
            indicators.heightAnchor.constraint(equalToConstant: 4)
        ]

        NSLayoutConstraint.activate(indicatorsConstraints)
        NSLayoutConstraint.activate(joinedDateLabelConstraints)
        NSLayoutConstraint.activate(joinDateImageViewConstraints)
        NSLayoutConstraint.activate(profileHeaderImageViewConstraints)
        NSLayoutConstraint.activate(displayNameLabelConstraints)
        NSLayoutConstraint.activate(userNameLabelConstraints)
        NSLayoutConstraint.activate(userBioLabelConstraints)
        NSLayoutConstraint.activate(followingCountLabelConstraints)
        NSLayoutConstraint.activate(followingTextLabelConstraints)
        NSLayoutConstraint.activate(followersCountLabelConstraints)
        NSLayoutConstraint.activate(followersTextLabelConstraints)
        NSLayoutConstraint.activate(sectionStackConstraints)
    }
    
    private func fillLayoutForIndicators() {
        for i in 0..<tabs.count {
            let leadingAnchor = indicators.leadingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].leadingAnchor)
            leadingAnchors.append(leadingAnchor)
            let trailingAnchor = indicators.trailingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].trailingAnchor)
            trailingAnchors.append(trailingAnchor)
        }
    }
    
    private struct FontSizeConstants {
        static let displayNameLabelFontSize: CGFloat = 22
        static let userNameLabelFontSize: CGFloat = 18
        static let followersTextLabelFontSize: CGFloat = 14
        static let followersCountLabelFontSize: CGFloat = 14
        static let followingTextLabelFontSize: CGFloat = 14
        static let followingCountLabelFontSize: CGFloat = 14
        static let joinedDateLabelFontSize: CGFloat = 14
    }
    private struct FontWeightConstants {
        static let displayNameLabelWeight: UIFont.Weight = .bold
        static let userNameLabelWeight: UIFont.Weight = .regular
        static let followersTextLabelWeight: UIFont.Weight = .regular
        static let followersCountLabelWeight: UIFont.Weight = .bold
        static let followingTextLabelWeight: UIFont.Weight = .regular
        static let followingCountLabelWeight: UIFont.Weight = .bold
        static let joinedDateLabelWeight: UIFont.Weight = .regular
    }
}


extension RawRepresentable {
    static prefix func ~(rhs: Self) -> Self.RawValue {
        rhs.rawValue
    }
}
