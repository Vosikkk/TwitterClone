//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by Саша Восколович on 06.10.2023.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    
    private let timelineTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timelineTableView)
        
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        
        configureNavigatioBar()
      
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timelineTableView.frame = view.frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
            print("fskjfhkls")
            present(vc, animated: false)
            print("11")
        }
    }
    
    private func configureNavigatioBar() {
        let size: CGFloat = 36
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image = UIImage(named: "twitter_logo")
        
        let middleView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        middleView.addSubview(logoImageView)
        navigationItem.titleView = middleView
        
        let profileImage = UIImage(systemName: "person")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(didTapProfile))
    }
    
    @objc private func didTapProfile() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        return cell
    }
}

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
