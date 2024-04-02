//
//  TaskViewModel.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 3/27/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

extension AuthenticationViewModel {
    func createTask(familyID: String, taskName: String, description: String, assigneeID: String, assignee: CustomUser, finishBy: Date) async {
        do {
            let task = TaskItem(
                taskName: taskName,
                description: description,
                assigneeID: assigneeID,
                finishBy: finishBy,
                familyID: familyID,
                progress: 0
            )
            
            let taskRef = try db.collection("tasks").addDocument(from: task)
            
            let taskItem = try await db.collection("tasks").document(taskRef.documentID).getDocument(as: TaskItem.self)
            
            let familyTask = db.collection("families").document(familyID).collection("tasks").document(taskRef.documentID)
            try await familyTask.setData([:])
            
            let extendedTask = ExtendedTaskItem(
                task: taskItem,
                assigneeFirstName: assignee.firstName
            )
            
            for i in 0..<self.extendedFamilies.count {
                if self.extendedFamilies[i].id == familyID {
                    self.extendedFamilies[i].tasks.append(extendedTask)
                    break
                }
            }
            
            if let user = user {
                if assigneeID == user.uid {
                    self.yourTasks.append(taskItem)
                }
            }
            
            print("Successfully created task, and fetched task.")
        } catch {
            print("Failed to create task")
        }
    }
    
    func getYourTasks() async -> [TaskItem]? {
        do {
            if let user = user {
                let querySnapshot = try await db.collection("tasks").whereField("assigneeID", isEqualTo: user.uid).getDocuments()
                
                var tasks = [TaskItem]()
                
                for document in querySnapshot.documents {
                    let task = try document.data(as: TaskItem.self)
                    tasks.append(task)
                }
                
                self.tasksLoading = false
                print("Successfully found your tasks.")
                return tasks
            }
        } catch {
            print("Failed to retrieve your tasks.")
        }
        
        return nil
    }
    
    func updateTaskProgress(taskID: String, familyID: String, progress: Int) async {
        do {
            let taskDoc = db.collection("tasks").document(taskID)
            try await taskDoc.updateData([
                "progress": progress
            ])
            
            for i in 0..<self.yourTasks.count {
                let id = yourTasks[i].id
                
                if id == taskID {
                    self.yourTasks[i].changeProgress(progress: progress)
                    break
                }
            }
            
            for i in 0..<self.extendedFamilies.count {
                let id = extendedFamilies[i].id
                
                if id == familyID {
                    for j in 0..<extendedFamilies[i].tasks.count {
                        if taskID == extendedFamilies[i].tasks[j].task.id {
                            self.extendedFamilies[i].tasks[j].task.changeProgress(progress: progress)
                            break
                        }
                    }
                }
            }
            
            print("Successfully updated progress.")
        } catch {
            print("Failed to update task progress.")
        }
    }
}
