//
//  ProfileViewModel.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/27/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

extension AuthenticationViewModel {
    func getFirstName() -> String {
        if let customUser = customUser {
            return customUser.firstName
        } else {
            return "Firstname not found."
        }
    }
    
    func getLastName() -> String {
        if let customUser = customUser {
            return customUser.lastName
        } else {
            return "Lastname not found."
        }
    }
    
    func getEmail() -> String {
        if let user = user, let email = user.email {
            return email
        } else {
            return "Could not find user's email."
        }
    }
}
