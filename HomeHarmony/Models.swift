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

public struct Family: Codable, Identifiable, Hashable {
    @DocumentID public var id: String?
    var familyName: String
    var creator: String
    var members: [String]
}

public struct ExtractedFamily: Identifiable {
    public var id: UUID = UUID()
    var familyName: String
    var creator: CustomUser
    var members: [CustomUser]
}

//public struct Task: Identifiable {
//    @DocumentID public var id: String?
//    var description: String
//    var assigneeID: String
//}
