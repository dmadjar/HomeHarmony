//
//  TaskViewModel.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 3/27/24.
//

import Foundation

extension AuthenticationViewModel {
    func createTask(familyID: String, taskName: String, description: String, assigneeID: String, assignee: CustomUser, finishBy: Date) async {
        var task = TaskItem(
            taskName: taskName,
            description: description,
            assigneeID: assigneeID,
            finishBy: finishBy,
            familyID: familyID,
            progress: 0
        )
        
        do {
            let taskRef = try db.collection("tasks").addDocument(from: task)
            
            let familyTask = db.collection("families").document(familyID).collection("tasks").document(taskRef.documentID)
            try await familyTask.setData([:])
            
            let extendedTask = ExtendedTaskItem(
                task: task,
                assigneeFirstName: assignee.firstName
            )
            
            await getYourTasks()
            
            self.tasks.append(extendedTask)
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
                
                let assignee = try await db.collection("users").document(task.assigneeID).getDocument(as: CustomUser.self)
                
                let extendedTask = ExtendedTaskItem(
                    task: task,
                    assigneeFirstName: assignee.firstName
                )
                
                self.tasks.append(extendedTask)
            }
            
            print("Retrieved family tasks.")
        } catch {
            print("Failed to retrieve tasks.")
        }
    }
    
    func getYourTasks() async {
        do {
            if let user = user {
                self.yourTasks.removeAll()
                
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
    
    func updateTaskProgress(taskID: String, progress: Int) async {
        do {
            let taskDoc = db.collection("tasks").document(taskID)
            try await taskDoc.updateData([
                "progress": progress
            ])
            
            for i in 0..<self.yourTasks.count {
                let id = yourTasks[i].id
                
                if id == taskID {
                    self.yourTasks[i].changeProgress(progress: progress)
                }
            }
            
            print("Successfully updated progress.")
        } catch {
            print("Failed to update task progress.")
        }
    }
}
