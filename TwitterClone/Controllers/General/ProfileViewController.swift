//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Саша Восколович on 10.10.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    private var isStatusBarHidden: Bool = true
    
    var profileAvatar = ProfileCustomUIView()
        
    private var avatarAnimationInProgress = false
    private var avatarMaxScaled = false
    private var headerMaxTransformed = false
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        view.addSubview(profileTableView)
        
        let header = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 420))
        navigationController?.navigationBar.isHidden = true
        profileTableView.dataSource = self
        profileTableView.delegate = self
        profileTableView.tableHeaderView = header   
        profileTableView.contentInsetAdjustmentBehavior = .never
        profileTableView.addSubview(profileAvatar)
        view.addSubview(statusBar)
        
        configureConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileAvatar.frame = CGRect(x: Constants.avatarX,
                                     y: (profileTableView.tableHeaderView!.bounds.height - Constants.avatarHeight) / 2.8,
                                     width: Constants.avatarWidth,
                                     height: Constants.avatarHeight)
       // updateParallaxOffset()
    }
    
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
            statusBar.heightAnchor.constraint(equalToConstant: AppStyle.statusBarHeight + 50)
        ]
        NSLayoutConstraint.activate(statusBarConstraints)
        NSLayoutConstraint.activate(profileTableViewConstraints)
    }
    
    private struct Constants {
        static let avatarWidth: CGFloat = 80
        static let avatarHeight: CGFloat = 80
        static let avatarX: CGFloat = 10
        static let minScale: CGFloat = 0.7
        static let maxScale: CGFloat = 1.0
        
        static let statusBarTrigger: CGFloat = 50
        static let translationOffset: CGFloat = 28

        static let animationDuration: TimeInterval = 0.3
    }
}
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let yPosition = scrollView.contentOffset.y
//        if yPosition > Constants.minScroll {
//            let scale = 1.0 - min(1.0, max(yPosition / 100, 0.0))
//            let clampedScale = max(min(scale, Constants.maxScale), Constants.minScale)
//            let translation = max(0, min(yPosition, Constants.translationOffset))
//
//            UIView.animate(withDuration: Constants.animationDuration) {
//                self.profileAvatar.transform = CGAffineTransform.identity.scaledBy(x: clampedScale, y: clampedScale)
//                self.profileAvatar.transform = self.profileAvatar.transform.translatedBy(x: 0, y: translation)
//            }
//        } else {
//            UIView.animate(withDuration: Constants.animationDuration) {
//                self.profileAvatar.transform = CGAffineTransform.identity.scaledBy(x: Constants.maxScale, y: Constants.maxScale)
//                self.profileAvatar.transform = self.profileAvatar.transform.translatedBy(x: 0, y: Constants.minScroll)
//            }
//        }
//
//        if yPosition > 25 && isStatusBarHidden {
//            isStatusBarHidden = false
//            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear, .beginFromCurrentState]) { [weak self] in
//                self?.statusBar.layer.opacity = 1
//            }
//        } else if yPosition < 0 && !isStatusBarHidden {
//            isStatusBarHidden = true
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
//                self?.statusBar.layer.opacity = 0
//            }
//        }
//    }
    
