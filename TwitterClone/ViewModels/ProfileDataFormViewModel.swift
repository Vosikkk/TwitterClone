//
//  ProfileDataFormViewModel.swift
//  TwitterClone
//
//  Created by Саша Восколович on 24.10.2023.
//

import Foundation
import Combine


class ProfileDataFormViewModel: ObservableObject {
    
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    
    
}
