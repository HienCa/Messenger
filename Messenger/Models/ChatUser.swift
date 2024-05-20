//
//  ChatUser.swift
//  Messenger
//
//  Created by Nguyen Van Hien on 8/5/24.
//

import Foundation
struct ChatUser: Identifiable{
    let uid, email, profileImageUrl: String
    var id: String{uid}
    
    init?(data: [String: Any]) {
            guard let uid = data["uid"] as? String,
                  let email = data["email"] as? String,
                  let profileImageUrl = data["profileImageUrl"] as? String else {
                return nil 
            }
            
            self.uid = uid
            self.email = email
            self.profileImageUrl = profileImageUrl
        }
}
