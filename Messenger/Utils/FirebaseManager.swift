//
//  FirebaseManager.swift
//  Messenger
//
//  Created by Nguyen Van Hien on 7/5/24.
//

import Foundation
import Firebase

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    let currentUser: User?
    static let shared = FirebaseManager()

    private override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        self.currentUser = auth.currentUser
        super.init()
    }
    
}
