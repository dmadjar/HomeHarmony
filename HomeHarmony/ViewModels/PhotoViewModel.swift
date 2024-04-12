//
//  ImagePickerViewModel.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/11/24.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

extension AuthenticationViewModel {
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    self.imageData = uiImage.jpegData(compressionQuality: 0.25)
                    self.profilePicture = Image(uiImage: UIImage(data: imageData!)!)
                }
            }
        } catch {
            print(error.localizedDescription)
            self.profilePicture = nil
        }
    }
    
    func uploadImage(user_id: String) {
        let imageRef = storageRef.child("profile/\(user_id).jpg")
        
        if let imageData = self.imageData {
            let uploadTask = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    return
                }
            }
        }
    }
    
    func fetchProfilePhoto() async {
        if let userId = user?.uid {
            let imageRef = storage.reference(withPath: "images/profile/\(userId).jpg")
            imageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    let uiImg = UIImage(data: data!)
                    if let uiImg = uiImg {
                        self.profilePicture = Image(uiImage: uiImg)
                        print("Fetched profile photo.")
                    }
                }
            }
        }
    }
}
