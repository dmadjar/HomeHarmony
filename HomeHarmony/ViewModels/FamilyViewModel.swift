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
        guard let user = user else {
            return
        }
        
        let family = Family(
            familyName: familyName,
            creator: user.uid
        )
        
        do {
            let familyId = try db.collection("families").addDocument(from: family)
            
            for member in members {
                if let memberId = member.id {
                    try await db.collection("users").document(memberId).collection("families").document(familyId.documentID).setData([:])
                    try await db.collection("families").document(familyId.documentID).collection("members").document(memberId).setData([:])
                }
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
    
    func getFam() async -> [ExtendedFamily]? {
        guard let user = user else {
            return nil
        }
        
        do {
            var localExtendedFamily = [ExtendedFamily]()
            
            let familySnapshot = try await db.collection("users").document(user.uid).collection("families").getDocuments()
            
            for familyDoc in familySnapshot.documents { // I think I could use TaskGroup to get these concurrently.
                let familyRef = db.collection("families").document(familyDoc.documentID)
        
                let family = try await familyRef.getDocument(as: Family.self)
                let creator = try await db.collection("users").document(family.creator).getDocument(as: CustomUser.self)
                
                var members = [CustomUser]()
                let memberSnapshot = try await familyRef.collection("members").getDocuments()
                for memberId in memberSnapshot.documents {
                    let member = try await db.collection("users").document(memberId.documentID).getDocument(as: CustomUser.self)
                    members.append(member)
                }
                
                var tasks = [ExtendedTaskItem]()
                let taskSnapshot = try await familyRef.collection("tasks").getDocuments()
                for taskId in taskSnapshot.documents {
                    let task = try await db.collection("tasks").document(taskId.documentID).getDocument(as: TaskItem.self)
                    let assignee = try await db.collection("users").document(task.assigneeID).getDocument(as: CustomUser.self)
                    let extendedTaskItem = ExtendedTaskItem(task: task, assigneeFirstName: assignee.firstName)
                    tasks.append(extendedTaskItem)
                }
                
                let extendedFamily = ExtendedFamily(
                    id: family.id,
                    familyName: family.familyName,
                    creator: creator,
                    members: members,
                    tasks: tasks
                )
                
                localExtendedFamily.append(extendedFamily)
            }
            
            self.familiesLoading = false
            print("Successfully retrieved families.")
            return localExtendedFamily
        } catch {
            print("Failed to retrieve family.")
            return nil
        }
    }
    
//    func getFamilies() async -> [ExtendedFamily]? {
//        if let user = user {
//            do {
//                var extendFamily = [ExtendedFamily]()
//                
//                let familySnapshot = try await db.collection("users").document(user.uid).collection("families").getDocuments()
//                
//                for familyDoc in familySnapshot.documents {
//                    let family = try await db.collection("families").document(familyDoc.documentID).getDocument(as: Family.self)
//                    let creator = try await db.collection("users").document(family.creator).getDocument(as: CustomUser.self)
//                    
//                    var members = [CustomUser]()
//                    for userId in family.members {
//                        let m = try await db.collection("users").document(userId).getDocument(as: CustomUser.self)
//                        members.append(m)
//                    }
//                    
//                    var tasks = [ExtendedTaskItem]()
//                    let taskSnapshot = try await db.collection("families").document(familyDoc.documentID).collection("tasks").getDocuments()
//                    for taskDoc in taskSnapshot.documents {
//                        let task = try await db.collection("tasks").document(taskDoc.documentID).getDocument(as: TaskItem.self)
//                        
//                        let assignee = try await db.collection("users").document(task.assigneeID).getDocument(as: CustomUser.self)
//                        
//                        let extendedTaskItem = ExtendedTaskItem(
//                            task: task,
//                            assigneeFirstName: assignee.firstName
//                        )
//                        
//                        tasks.append(extendedTaskItem)
//                    }
//                    
//                    let extendedFamily = ExtendedFamily(
//                        id: family.id,
//                        familyName: family.familyName,
//                        creator: creator,
//                        members: members,
//                        tasks: tasks
//                    )
//                    
//                    extendFamily.append(extendedFamily)
//                }
//                
//               
//                self.familiesLoading = false
//                print("Successfully retrieved families.")
//                return extendFamily
//            } catch {
//                print("Failed to retrieve family.")
//            }
//        }
//        
//        return nil
//    }
}
