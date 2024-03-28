//
//  MainViewModel.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/18/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

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
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var firstName = ""
    @Published var lastName = ""
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage = ""
    
    @Published var user: User?
    @Published var customUser: CustomUser?
    
    @Published var usersNotFriends: [CustomUser] = []
    @Published var requestsSent: [String?] = []
    @Published var friendRequests: [CustomUser] = []
    @Published var friends: [CustomUser] = []
    
    
    @Published var families: [ExtractedFamily] = []
    @Published var familiesLoading: Bool = false
    
    
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
    
    
    func reset() {
        self.email = ""
        self.password = ""
        self.confirmPassword = ""
        self.friends = []
        self.friendRequests = []
        self.families = []
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
}

extension AuthenticationViewModel {
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
    
    func getUser() async {
        if let user = user {
            self.familiesLoading = true
            
            let docRef = db.collection("users").document(user.uid)
            
            do {
                self.customUser = try await docRef.getDocument(as: CustomUser.self)
                print("Succesfully found User.")
            } catch {
                print("Error decoding user: \(error.localizedDescription)")
            }
        } else {
            print("Could not find user id.")
        }
    }
    
    func getAllUsersNotFriends() async {
        self.usersNotFriends.removeAll()
        
        do {
            if let user = user {
                let querySnapshot = try await db.collection("users").whereField(FieldPath.documentID(), isNotEqualTo: user.uid).getDocuments()
                
                for document in querySnapshot.documents {
                    do {
                        let userData = try document.data(as: CustomUser.self)
                        self.usersNotFriends.append(userData)
                        print("Found User!")
                    } catch {
                        print("Error getting user: \(error.localizedDescription)")
                    }
                }
                
                self.usersNotFriends = self.usersNotFriends.filter {
                    for friend in self.friends {
                        if friend.id == $0.id {
                            return false
                        }
                    }
                    
                    return true
                }
            }
        } catch {
            print("Error getting user documents: \(error.localizedDescription)")
        }
    }
    
    func sendFriendRequest(friendId: String?) {
        if let friendId = friendId {
            if let user = user {
                let friendRef = db.collection("users").document(friendId).collection("requests").document(user.uid)
                friendRef.setData([:])
                
                self.requestsSent.append(friendId)
                
                print("Sent request!")
            }
        }
    }
    
    func getFriendRequests() async {
        self.friendRequests.removeAll()

        if let user = user {
            do {
                let requests = try await db.collection("users").document(user.uid).collection("requests").getDocuments()
                
                for request in requests.documents {
                    let friend = try await db.collection("users").document(request.documentID).getDocument(as: CustomUser.self)
                    self.friendRequests.append(friend)
                }
                
                print("Successfully found friend requests.")
            } catch {
                print("Could not find friend requests.")
            }
        }
    }
    
    func getFriends() async {
        self.friends.removeAll()
        
        if let user = user {
            do {
                let userFriends = try await db.collection("users").document(user.uid).collection("friends").getDocuments()
                
                for friend in userFriends.documents {
                    let f = try await db.collection("users").document(friend.documentID).getDocument(as: CustomUser.self)
                    self.friends.append(f)
                }
            } catch {
                print("Could not get friends.")
            }
        }
    }
    
    func acceptRequest(requestId: String?) async {
        if let user = user, let requestId = requestId {
            do {
                let userRef = db.collection("users").document(user.uid).collection("friends").document(requestId)
                try await  userRef.setData([:])
                
                let friendRef = db.collection("users").document(requestId).collection("friends").document(user.uid)
                try await friendRef.setData([:])
                
                await declineRequest(requestId: requestId)
                
                let f = try await db.collection("users").document(requestId).getDocument(as: CustomUser.self)
                self.friends.append(f)
              
                print("Successfully accepted friend request.")
            } catch {
                print("Could not accept friend request.")
            }
        }
    }
    
    func declineRequest(requestId: String?) async {
        do {
            if let user = user, let requestId = requestId {
                try await db.collection("users").document(user.uid).collection("requests").document(requestId).delete()
                
                self.friendRequests = self.friendRequests.filter {
                    $0.id != requestId
                }
                
                print("Successfully declined friend request.")
            }
        } catch {
            print("Could not decline friend request.")
        }
    }
    
    func requested(friendId: String?) -> Bool {
        if let friendId = friendId {
            for request in self.requestsSent {
                if let request = request {
                    if request == friendId {
                        return true
                    }
                }
            }
        }
        
        return false
    }
}
