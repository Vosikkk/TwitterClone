//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by Саша Восколович on 06.10.2023.
//

import UIKit
import FirebaseAuth
import Combine

class HomeViewController: UIViewController {
    
    
    // MARK: - Properties
    
    private let timelineTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()
    
    private let authenticationViewModel: AuthenticationViewModel
    
    private let homeViewModel: HomeViewModel
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private let commonFactory: GeneralFactory
    
    private let profileViewModel: ProfileDataFormViewModel
    
    
    // MARK: - Init
    
    init(authenticationViewModel: AuthenticationViewModel,
         homeViewModel: HomeViewModel,
         commonFactory: GeneralFactory,
         profileViewModel: ProfileDataFormViewModel) {
        
        self.authenticationViewModel = authenticationViewModel
        self.homeViewModel = homeViewModel
        self.commonFactory = commonFactory
        self.profileViewModel = profileViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("HomeViewController деініціалізований")
    }
    
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timelineTableView)
        
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        configureNavigatiorBar()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(didTapSignOut))
        bindViews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timelineTableView.frame = view.frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        handleAuthentication()
        homeViewModel.retreiveUser()
    }
    
    
    // MARK: - Func
    
    func compliteUserOnboarding() {
        let vc = ProfileDataFormViewController(commonFactory: commonFactory, 
                                               profileViewModel: profileViewModel)
        present(vc, animated: true)
    }
    
    private func bindViews() {
        homeViewModel.$user.sink { [weak self] user in
            guard let user = user else { return }
            if !user.isUserOnboarded {
                self?.compliteUserOnboarding()
            }
        }
        .store(in: &subscriptions)
    }
    
    private func handleAuthentication() {
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(
                rootViewController:
                    OnboardingViewController(authenticationViewModel: authenticationViewModel, commonFactory: commonFactory))
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
    
    private func configureNavigatiorBar() {
        
        let logoImageView = UIImageView(frame:
                                            CGRect(x: PositionConstants.logoImageViewX,
                                                   y: PositionConstants.logoImageViewY,
                                                   width: SizeConstants.widthForNavigatorView,
                                                   height: SizeConstants.heightForNavigatorView))
        
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image = UIImage(named: "twitter_logo")
        
        let middleView = UIView(frame:
                                    CGRect(x: PositionConstants.middleViewX,
                                           y: PositionConstants.middleViewY,
                                           width: SizeConstants.widthForNavigatorView,
                                           height: SizeConstants.heightForNavigatorView))
        
        middleView.addSubview(logoImageView)
        navigationItem.titleView = middleView
        
        let profileImage = UIImage(systemName: "person")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(didTapProfile))
    }
    
    
    // MARK: - @objc Func
    
    @objc private func didTapSignOut() {
        try? Auth.auth().signOut()
        handleAuthentication()
        authenticationViewModel.clearData()
    }
    
    
    @objc private func didTapProfile() {
        let vc = ProfileViewController(commonFactory: commonFactory)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Nested Type
    
    private struct SizeConstants {
        static let widthForNavigatorView: CGFloat = 36
        static let heightForNavigatorView: CGFloat = 36
        static let numberOfRows: Int = 10
    }
    
    private struct PositionConstants {
        static let logoImageViewX: CGFloat = 0
        static let logoImageViewY: CGFloat = 0
        static let middleViewX: CGFloat = 0
        static let middleViewY: CGFloat = 0
        
    }
}


// MARK: - UITableViewDelegate & UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SizeConstants.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        return cell
    }
}

// MARK: - TweetTableViewCellDelegate

extension HomeViewController: TweetTableViewCellDelegate {
    func tweetTableViewCellDidTapReply() {
        print("It's reply")
    }
    
    func tweetTableViewCellDidTapRetweet() {
        print("It's retweet")
    }
    
    func tweetTableViewCellDidTapLike() {
        print("IT's like")
    }
    
    func tweetTableViewCellDidTapShare() {
        print("I's share")
    }
}
