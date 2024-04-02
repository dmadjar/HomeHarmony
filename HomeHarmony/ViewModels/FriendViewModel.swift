//
//  FriendViewModel.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/1/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

extension AuthenticationViewModel {
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
    
    func getFriendRequests() async -> [CustomUser]? {
        if let user = user {
            do {
                let requests = try await db.collection("users").document(user.uid).collection("requests").getDocuments()
                
                var localFriendRequests = [CustomUser]()
                
                for request in requests.documents {
                    let friend = try await db.collection("users").document(request.documentID).getDocument(as: CustomUser.self)
                    localFriendRequests.append(friend)
                }
                
                self.friendsLoading = false
                print("Successfully found friend requests.")
                return localFriendRequests
            } catch {
                print("Could not find friend requests.")
            }
        }
        
        return nil
    }
    
    func getFriends() async -> [CustomUser]? {
        if let user = user {
            do {
                let userFriends = try await db.collection("users").document(user.uid).collection("friends").getDocuments()
                
                var localFriends = [CustomUser]()
                for friend in userFriends.documents {
                    let f = try await db.collection("users").document(friend.documentID).getDocument(as: CustomUser.self)
                    localFriends.append(f)
                }
                
                print("Sucessfully found friends")
                return localFriends
            } catch {
                print("Could not get friends.")
            }
        }
        
        return nil
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
