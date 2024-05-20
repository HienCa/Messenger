//
//  ChatMessage.swift
//  Messenger
//
//  Created by Nguyen Van Hien on 9/5/24.
//

import Foundation
import Firebase
struct FirebaseConstants{
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let timestamp = "timestamp"
    static let profileImageUrl = "profileImageUrl"
    static let email = "email"
}

struct ChatMessage: Identifiable{
    var id: String {documentId}
    let documentId: String
    let fromId, toId, text: String
    
    init(documentId: String, data: [String: Any]){
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""

        self.documentId = documentId
    }
}

struct RecentMessage: Codable, Identifiable{
    var id: String {documentId}
    let documentId: String
    let fromId, toId, text, profileImageUrl, email: String
    let timestamp: Timestamp
    init(documentId: String, data: [String: Any]){
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
        self.timestamp = data[FirebaseConstants.timestamp] as? Timestamp ?? Timestamp(date: Date())
        self.profileImageUrl = data[FirebaseConstants.profileImageUrl] as? String ?? ""
        self.email = data[FirebaseConstants.email] as? String ?? ""
        self.documentId = documentId
    }
}
