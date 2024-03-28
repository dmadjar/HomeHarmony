//
//  TaskViewModel.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 3/27/24.
//

import Foundation

extension AuthenticationViewModel {
    func createTask(familyID: String, taskName: String, description: String, assigneeID: String, finishBy: Date) async {
        let task = TaskItem(
            taskName: taskName,
            description: description,
            assigneeID: assigneeID,
            finishBy: finishBy,
            familyID: familyID
        )
        
        do {
            let taskRef = try db.collection("tasks").addDocument(from: task)
            
            let familyTask = db.collection("families").document(familyID).collection("tasks").document(taskRef.documentID)
            try await familyTask.setData([:])
            
            self.tasks.append(task)
            print("Successfully created task.")
        } catch {
            print("Failed to create task")
        }
    }
    
    func getTasks(familyID: String) async {
        do {
            self.tasks.removeAll()
            
            let querySnapshot = try await db.collection("tasks").whereField("familyID", isEqualTo: familyID).getDocuments()
            
            for document in querySnapshot.documents {
                let task = try document.data(as: TaskItem.self)
                
                self.tasks.append(task)
            }
            
            print("Retrieved family tasks.")
        } catch {
            print("Failed to retrieve tasks.")
        }
    }
    
    func getYourTasks() async {
        do {
            if let user = user {
                let querySnapshot = try await db.collection("tasks").whereField("assigneeID", isEqualTo: user.uid).getDocuments()
                
                for document in querySnapshot.documents {
                    let task = try document.data(as: TaskItem.self)
                    self.yourTasks.append(task)
                }
                
                print("Successfully found your tasks.")
            }
        } catch {
            print("Failed to retrieve your tasks.")
        }
    }
}
