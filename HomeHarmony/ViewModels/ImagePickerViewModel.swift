//
//  ImagePickerViewModel.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/11/24.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

@MainActor
class ImagePickerViewModel: ObservableObject {
    let storageRef = Storage.storage().reference().child("images")

    @Published var image: Image?
    @Published var imageData: Data?
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                Task {
                    try await loadTransferable(from: imageSelection)
                }
            }
        }
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws -> Data? {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    self.image = Image(uiImage: uiImage)
                    self.imageData = data
                }
            }
        } catch {
            print(error.localizedDescription)
            image = nil
        }
        
        return nil
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
}
