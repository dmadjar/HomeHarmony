//
//  FamilyViewModel.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/27/24.
//


import Foundation
import FirebaseCore
import FirebaseFirestore

extension AuthenticationViewModel {
    func createFamily(familyName: String, members: Set<CustomUser>) async {
        if let user = user {
            var member_ids: [String] = [user.uid]
            for member in members {
                if let id = member.id {
                    member_ids.append(id)
                }
            }
            
            let family = Family(
                familyName: familyName,
                creator: user.uid,
                members: member_ids
            )
            
            do {
                let familyId = try db.collection("families").addDocument(from: family)
                
                for id in member_ids {
                    let userFamilies = db.collection("users").document(id).collection("families").document(familyId.documentID)
                    try await userFamilies.setData([:])
                }
                
                if let customUser = customUser {
                    let extractedFamily = ExtractedFamily(
                        familyName: familyName,
                        creator: customUser,
                        members: Array(members)
                    )
                    
                    self.families.append(extractedFamily)
                }
                
                print("Successfully created family.")
            } catch {
                print("Failed to create family.")
            }
        }
    }
    
    func getFamilies() async {
        if let user = user {
            do {
                self.familiesLoading = true
                
                self.families.removeAll()
                
                let querySnapshot = try await db.collection("users").document(user.uid).collection("families").getDocuments()
                
                for doc in querySnapshot.documents {
                    let family = try await db.collection("families").document(doc.documentID).getDocument(as: Family.self)
                    
                    let creator = try await db.collection("users").document(family.creator).getDocument(as: CustomUser.self)
                    
                    var members = [CustomUser]()
                    for userId in family.members {
                        let m = try await db.collection("users").document(userId).getDocument(as: CustomUser.self)
                        members.append(m)
                    }
                    
                    let extractedFamily = ExtractedFamily(
                        familyName: family.familyName,
                        creator: creator,
                        members: members
                    )
                    
                    self.families.append(extractedFamily)
                }
                
                self.familiesLoading = false
                print("Successfully retrieved families.")
            } catch {
                print("Failed to retrieve users families.")
            }
        }
    }
    
    func isLoading() -> Bool {
        return self.familiesLoading
    }
}
