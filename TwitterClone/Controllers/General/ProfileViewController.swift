//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Саша Восколович on 10.10.2023.
//

import UIKit
import Combine
import SDWebImage

class ProfileViewController: UIViewController {

    
    // MARK: - Properties
    
    private var isStatusBarHidden: Bool = true
    
    var profileAvatar = ProfileCustomUIView()
    
    private let commonFactory: GeneralFactory
    
    private let profileViewViewModel: ProfileViewViewModel
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private let statusBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0
        view.backgroundColor = .systemBackground
        return view
    }()
    
    
    private let profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var headerView = ProfileTableViewHeader(frame:
                                                        CGRect(x: 0, y: 0,
                                                               width: profileTableView.frame.width,
                                                               height: SizeConstants.headerHeight),
                                                    commonFactory: commonFactory)
    
    
    init(commonFactory: GeneralFactory, profileViewViewModel: ProfileViewViewModel) {
        self.commonFactory = commonFactory
        self.profileViewViewModel = profileViewViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        view.addSubview(profileTableView)
        
       
        
        navigationController?.navigationBar.isHidden = true
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        profileTableView.tableHeaderView = headerView
        profileTableView.contentInsetAdjustmentBehavior = .never
        profileTableView.addSubview(profileAvatar)
        
        view.addSubview(statusBar)
        
       
        
        configureConstraints()
        
        bindViews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileViewViewModel.retreiveUser()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileAvatar.frame = CGRect(x: Constants.avatarX,
                                     y: (profileTableView.tableHeaderView!.bounds.height - SizeConstants.avatarHeight) / 2.8,
                                     width: SizeConstants.avatarWidth,
                                     height: SizeConstants.avatarHeight)
       
    }
    
    // MARK: - Func
    
    private func bindViews() {
        profileViewViewModel.$user.sink { [weak self] user in
            guard let user = user else { return }
            self?.headerView.displayNameLabel.text = user.displayName
            self?.headerView.userNameLabel.text = "@\(user.username)"
            self?.headerView.followersCountLabel.text = "\(user.followersCount)"
            self?.headerView.followingCountLabel.text = "\(user.followingCount)"
            self?.headerView.userBioLabel.text = user.bio
            self?.profileAvatar.setAvatarImage(url: URL(string: user.avatarPath))
            self?.headerView.joinedDateLabel.text = "Joined \(self?.profileViewViewModel.getFormattedDate(with: user.createdOn) ?? "")"
            
        }
        .store(in: &subscriptions)
    }
   
    private func configureConstraints() {
        let profileTableViewConstraints = [
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        let statusBarConstraints = [
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: AppStyle.statusBarHeight + SizeConstants.statusBarOffset)
        ]
        NSLayoutConstraint.activate(statusBarConstraints)
        NSLayoutConstraint.activate(profileTableViewConstraints)
    }
    
    
    
        // MARK: - Animation
    
    private func updateParallaxOffset(_ offset: CGFloat) {
        let parallaxOffset = offset / 2 // Змініть значення залежно від бажаного ефекту
      
            let avatarScale = max(1 - parallaxOffset / 100, Constants.minScale)
            let translation = max(0, min(parallaxOffset, Constants.translationOffset))
            
            // Застосовуємо трансформацію до профільного аватара
            self.profileAvatar.transform = CGAffineTransform.identity.scaledBy(x: avatarScale, y: avatarScale)
            self.profileAvatar.transform = self.profileAvatar.transform.translatedBy(x: 0, y: translation)
        
    }
    
    private func updateStatusBar(_ offset: CGFloat) {
        if offset > Constants.statusBarTrigger {
            if isStatusBarHidden {
                isStatusBarHidden = false
                UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
                    self?.statusBar.layer.opacity = 1
                }
            }
        } else {
            if !isStatusBarHidden {
                isStatusBarHidden = true
                UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
                    self?.statusBar.layer.opacity = 0
                }
            }
        }
    }
    
    
    // MARK: - Nested Type
    
    private struct Constants {
        static let avatarX: CGFloat = 10
        static let minScale: CGFloat = 0.7
        static let maxScale: CGFloat = 1.0
        
        static let statusBarTrigger: CGFloat = 50
        static let translationOffset: CGFloat = 28

        static let animationDuration: TimeInterval = 0.3
    }
    
    private struct SizeConstants {
        static let headerHeight: CGFloat = 420
        static let avatarWidth: CGFloat = 80
        static let avatarHeight: CGFloat = 80
        static let tableViewNumberOfRow: Int = 4
        static let statusBarHeightDefault: CGFloat = 80
        static let statusBarOffset: CGFloat = 50
    }
}


// MARK: - UITableViewDelegate & UITableViewDataSource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SizeConstants.tableViewNumberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else { return UITableViewCell() }
        
                
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = profileTableView.contentOffset.y
        if yOffset > 0 {
            updateParallaxOffset(yOffset)
        }
        updateStatusBar(yOffset)
      }
}

struct AppStyle {
    static var statusBarHeight: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let barHeight = windowScene.statusBarManager?.statusBarFrame.height {
            return barHeight
        } else {
            return 80
        }
    }
}
