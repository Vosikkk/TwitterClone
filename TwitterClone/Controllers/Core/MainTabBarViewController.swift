//
//  MainTabBarViewController.swift
//  TwitterClone
//
//  Created by Саша Восколович on 06.10.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let userAuth: AuthManager = UserAuth()
        let storageUserManager: DatabaseManager = StorageUserManager()
        let homeViewModel = HomeViewModel(storageUserManager: storageUserManager)
        let authenticationViewModel = AuthenticationViewModel(userAuth: userAuth, storageUserManager: storageUserManager)
        
        
        let vc1 = UINavigationController(rootViewController: HomeViewController(authenticationViewModel: authenticationViewModel, homeViewModel: homeViewModel))
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: NotificationsViewController())
        let vc4 = UINavigationController(rootViewController: DirectMessagesViewController())
        
        
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc1.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        vc3.tabBarItem.image = UIImage(systemName: "bell")
        vc3.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")
        
        vc4.tabBarItem.image = UIImage(systemName: "envelope")
        vc4.tabBarItem.selectedImage = UIImage(systemName: "envelope.fill")
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }

    deinit {
            print("MainTabBarViewController деініціалізований")
        }
}

