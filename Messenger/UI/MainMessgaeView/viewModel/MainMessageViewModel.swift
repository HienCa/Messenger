//
//  MainMessageViewModel.swift
//  Messenger
//
//  Created by Nguyen Van Hien on 8/5/24.
//

import Foundation
class MainMessageViewModel: ObservableObject{
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var isUserCurrentlyLoggedOut = false
    @Published var recentMessages = [RecentMessage]()
    
    init(){

        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchCurrentUser()
    }
    
    func fetchCurrentUser(){
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find direbase uid"
            return
        }

        FirebaseManager.shared.firestore.collection(Constants.COLLECTION.User)
            .document(uid).getDocument(completion: {
                snapshot, err in
                if let err = err{
                    self.errorMessage = "Failed to getach current user: \(err)"
                    return
                }
                
                guard let data = snapshot?.data() else {
                    self.errorMessage = "No data found"
                    return
                }
                
                if let chatUser = ChatUser(data: data)	{
                    self.chatUser = chatUser
                    self.fetchRecentMessages()
                }
        })
    }
    
    private func fetchRecentMessages(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        FirebaseManager.shared.firestore
            .collection(Constants.COLLECTION.RecentMessage)
            .document(uid)
            .collection(Constants.COLLECTION.Messages)
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener{
                querySnapshot, error in
                if let error = error{
                    self.errorMessage = "Failed to listen for recent messgaes: \(error)"
                    return
                }
                
                querySnapshot?.documentChanges.forEach({change in

                    let docId = change.document.documentID
                    if let index = self.recentMessages.firstIndex(where: {rm in
                        return rm.documentId == docId
                    }){
                        self.recentMessages.remove(at: index)
                    }
                    self.recentMessages.append(.init(documentId: docId, data: change.document.data()))
                })
            }
    }
    
    func handleSignOut(){
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    
}
