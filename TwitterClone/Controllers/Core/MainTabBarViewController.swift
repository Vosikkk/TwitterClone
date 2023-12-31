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
        
        
        let buttonFactory = ButtonFactory()
        let textFieldFactory = TextFieldFactory()
        let labelFactory = LabelFactory()
        
        
       
        
        let commonFactory = GeneralFactory(buttonFactory: buttonFactory,
                                          textFieldFactory: textFieldFactory,
                                          labelFactory: labelFactory)
       
       
        let userStorageManager: StorageManager = UserStorageManager()
        let userAuth: AuthManager = UserAuth()
        let userDatabaseManager: DatabaseManager = UserDatabaseManager()
        
        
        let homeViewModel = HomeViewModel(userDatabaseManager: userDatabaseManager)
        let profileDataViewModel = ProfileDataFormViewModel(userStorageManager: userStorageManager, databaseManager: userDatabaseManager)
        let authenticationViewModel = AuthenticationViewModel(userAuth: userAuth, userDatabaseManager: userDatabaseManager)
        let profileViewViewModel = ProfileViewViewModel(userDatabaseManager: userDatabaseManager)
        let composeViewModel = TweetComposeViewModel(userDatabaseManager: userDatabaseManager)
        
        let vc1 = UINavigationController(rootViewController: HomeViewController(authenticationViewModel: authenticationViewModel,
                                                                                homeViewModel: homeViewModel,
                                                                                commonFactory: commonFactory,
                                                                                profileDataViewModel: profileDataViewModel,
                                                                                profileViewViewModel: profileViewViewModel,
                                                                                composeViewModel: composeViewModel
                                                                               ))
        
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

