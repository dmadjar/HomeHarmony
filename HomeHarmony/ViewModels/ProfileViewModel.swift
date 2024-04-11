//
//  ProfileViewModel.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/27/24.
//

import SwiftUI
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
    
    func fetchProfilePhoto() {
        
        if let userId = user?.uid {
            let imageRef = storage.reference(withPath: "images/profile/\(userId).jpg")
            print(imageRef)
            
            imageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    let uiImg = UIImage(data: data!)
                    if let uiImg = uiImg {
                        self.profilePicture = Image(uiImage: uiImg)
                    }
                }
            }
        }
    }
}
