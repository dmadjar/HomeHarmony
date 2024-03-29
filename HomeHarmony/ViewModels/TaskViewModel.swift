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
            
            for i in 0..<self.extendedFamilies.count {
                if extendedFamilies[i].id == familyID {
                    extendedFamilies[i].tasks.append(extendedTask)
                    break
                }
            }
            
            if let user = user {
                task.id = taskRef.documentID // Line causes warning
                if assigneeID == user.uid {
                    yourTasks.append(task)
                }
            }
            
            print("Successfully created task.")
        } catch {
            print("Failed to create task")
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
                
                self.tasksLoading = false
                print("Successfully found your tasks.")
            }
        } catch {
            print("Failed to retrieve your tasks.")
        }
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
