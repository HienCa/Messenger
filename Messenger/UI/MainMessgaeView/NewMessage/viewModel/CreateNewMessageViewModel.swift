//
//  CreateNewMessageViewModel.swift
//  Messenger
//
//  Created by Nguyen Van Hien on 8/5/24.
//

import Foundation
class CreateNewMessageViewModel: ObservableObject{
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers(){
        FirebaseManager.shared.firestore.collection(Constants.COLLECTION.User)
            .getDocuments(completion: {
                snapshot, err in
                if let err = err{
                    self.errorMessage = "Failed to fetch users: \(err)"
                    return
                }
                
                snapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    if let user = ChatUser(data: data) {
                        if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                            self.users.append(user)
                        }
                    } else {
                        print("Failed to create ChatUser from data: \(data)")
                    }
                })
            })
    }
}
