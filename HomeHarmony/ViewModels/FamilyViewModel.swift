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
            var member_ids: [String] = []
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
                
                if let creator = customUser {
                    let extendedFamily = ExtendedFamily(
                        id: familyId.documentID,
                        familyName: familyName,
                        creator: creator, 
                        members: Array(members),
                        tasks: []
                    )
                    
                    self.extendedFamilies.append(extendedFamily)
                }
                
                print("Successfully created family.")
            } catch {
                print("Failed to create family.")
            }
        }
    }
    
    func getFamilies() async -> [ExtendedFamily]? {
        if let user = user {
            do {
                var extendFamily = [ExtendedFamily]()
                
                let familySnapshot = try await db.collection("users").document(user.uid).collection("families").getDocuments()
                
                for familyDoc in familySnapshot.documents {
                    let family = try await db.collection("families").document(familyDoc.documentID).getDocument(as: Family.self)
                    
                    let creator = try await db.collection("users").document(family.creator).getDocument(as: CustomUser.self)
                    
                    var members = [CustomUser]()
                    for userId in family.members {
                        let m = try await db.collection("users").document(userId).getDocument(as: CustomUser.self)
                        members.append(m)
                    }
                    
                    var tasks = [ExtendedTaskItem]()
                    let taskSnapshot = try await db.collection("families").document(familyDoc.documentID).collection("tasks").getDocuments()
                    for taskDoc in taskSnapshot.documents {
                        let task = try await db.collection("tasks").document(taskDoc.documentID).getDocument(as: TaskItem.self)
                        
                        let assignee = try await db.collection("users").document(task.assigneeID).getDocument(as: CustomUser.self)
                        
                        let extendedTaskItem = ExtendedTaskItem(
                            task: task,
                            assigneeFirstName: assignee.firstName
                        )
                        
                        tasks.append(extendedTaskItem)
                    }
                    
                    let extendedFamily = ExtendedFamily(
                        id: family.id,
                        familyName: family.familyName,
                        creator: creator,
                        members: members,
                        tasks: tasks
                    )
                    
                    extendFamily.append(extendedFamily)
                }
                
               
                self.familiesLoading = false
                print("Successfully retrieved families.")
                return extendFamily
            } catch {
                print("Failed to retrieve family.")
            }
        }
        
        return nil
    }
}
