//
//  Models.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/25/24.
//

import Foundation
import FirebaseFirestore

public struct CustomUser: Codable, Identifiable, Hashable {
    @DocumentID public var id: String?
    var firstName: String
    var lastName: String
    // var requests: [String]?
}

public struct TaskItem: Codable, Identifiable {
    @DocumentID public var id: String?
    var taskName: String
    var description: String
    var assigneeID: String
    var finishBy: Date
    var familyID: String
    var progress: Int
    var taskColor: Int
    
    mutating func changeProgress(progress: Int) {
        self.progress = progress
    }
}

public struct ExtendedTaskItem {
    var task: TaskItem
    var assigneeFirstName: String
}

public struct Family: Codable, Identifiable, Hashable {
    @DocumentID public var id: String?
    var familyName: String
    var creator: String
//    var members: [String]
}

public struct ExtendedFamily: Identifiable {
    public var id: String?
    var familyName: String
    var creator: CustomUser
    var members: [CustomUser]
    var tasks: [ExtendedTaskItem]
}





