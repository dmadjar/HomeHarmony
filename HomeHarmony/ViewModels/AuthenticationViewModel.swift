//
//  MainViewModel.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/18/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let storageRef = Storage.storage().reference().child("images")

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
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var firstName = ""
    @Published var lastName = ""
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage = ""
    
    @Published var user: User?
    @Published var customUser: CustomUser?
    @Published var profilePicture: Image?
    
    @Published var usersNotFriends: [ExtendedCustomUser] = []
    
    @Published var requestsSent: [String?] = []
    @Published var friendRequests: [CustomUser] = []
    @Published var friends: [CustomUser] = []
    
    @Published var extendedFamilies: [ExtendedFamily] = []
    
    @Published var friendsLoading: Bool = false
    @Published var tasksLoading: Bool = false
    @Published var familiesLoading: Bool = false
    
    @Published var yourTasks: [TaskItem] = []
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    init() {
        registerAuthStateHandler()
    }
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil
                    ? .unauthenticated
                    : .authenticated
            }
        }
    }
    
    func fetchData() async {
        setDataLoading()
        
        let clock = ContinuousClock()
        let result = await clock.measure {
            async let custUser = getUser()
            async let families = getFam()
            async let tasks = getYourTasks()
            async let friRequests = getFriendRequests()
            async let fri = getFriends()
            
            self.customUser = await custUser
            self.yourTasks = await tasks ?? []
            self.friendRequests = await friRequests ?? []
            self.friends = await fri ?? []
            self.extendedFamilies = await families ?? []
            self.fetchProfilePhoto()
        }
        
        print(result)
    }
    
//    func fetchData() async {
//        setDataLoading()
//        
//        let clock = ContinuousClock()
//        
//        let result = await clock.measure {
//            self.customUser = await getUser()
//            self.yourTasks = await getYourTasks() ?? []
//            self.friendRequests = await getFriendRequests() ?? []
//            self.friends = await getFriends() ?? []
//            self.extendedFamilies = await getFam() ?? []
//        }
//        
//        print(result)
//    }
    
    func reset() {
        self.email = ""
        self.password = ""
        self.confirmPassword = ""
        self.firstName = ""
        self.lastName = ""
        self.errorMessage = ""
        self.customUser = nil
        self.usersNotFriends = []
        self.requestsSent = []
        self.friendRequests = []
        self.friends = []
        self.extendedFamilies = []
        self.yourTasks = []
        self.imageData = nil
        self.imageSelection = nil
    }
    
    func setDataLoading() {
        self.friendsLoading = true
        self.familiesLoading = true
        self.tasksLoading = true
    }
}

extension AuthenticationViewModel {
    func signUpWithEmailPassword() async -> Bool {
        self.authenticationState = .authenticating
        
        do {
            try await Auth.auth().createUser(withEmail: self.email, password: self.password)
            
            if let user = self.user {
                createUser(user)
            }
            
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signInWithEmailPassword() async {
        self.authenticationState = .authenticating
        
        do {
            try await Auth.auth().signIn(withEmail: self.email, password: self.password)
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
          try await user?.delete()
          return true
        }
        catch {
          errorMessage = error.localizedDescription
          return false
        }
    }
    
    func createUser(_ user: FirebaseAuth.User) {
        let customUser = CustomUser(
            firstName: self.firstName,
            lastName: self.lastName
        )
        
        let userRef = db.collection("users").document(user.uid)
        
        do {
            try userRef.setData(from: customUser)
            print("User Created Successfully!")
        } catch {
            print("Error creating user document: \(error.localizedDescription)")
        }
    }
    
    func getUser() async -> CustomUser? {
        if let user = user {
            let docRef = db.collection("users").document(user.uid)
            do {
                let custUser = try await docRef.getDocument(as: CustomUser.self)
                print("Succesfully found User.")
                return custUser
            } catch {
                print("Error decoding user: \(error.localizedDescription)")
            }
        }
        
        return nil
    }
}
