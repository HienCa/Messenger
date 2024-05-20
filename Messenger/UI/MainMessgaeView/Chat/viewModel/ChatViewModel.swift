//
//  ChatViewModel.swift
//  Messenger
//
//  Created by Nguyen Van Hien on 8/5/24.
//

import SwiftUI
import Firebase
class ChatViewModel: ObservableObject{
    @Published var chatText = ""
    @Published var errorMessage = ""
    @Published var chatMessages = [ChatMessage]()
    @Published var count = 0

    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?){
        self.chatUser = chatUser
        fetchMesages()
    }
    
    private func fetchMesages(){
        guard let fromId =  FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = chatUser?.uid else {return}
        FirebaseManager.shared.firestore
            .collection(Constants.COLLECTION.Messages)
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener{
                querySnapshot, err in
                if let err = err{
                    self.errorMessage = "Failed to listen for messages: \(err)"
                    return
                }
                
                querySnapshot?.documentChanges.forEach({
                    dataChange in
                    if dataChange.type == .added{
                        let data = dataChange.document.data()
                        let docId = dataChange.document.documentID
                        self.chatMessages.append(.init(documentId: docId, data: data))
                    }
                })
                
                DispatchQueue.main.async {
                    self.count += 1
                }
            }
    }
    
    func handleSend(){
        print(chatText)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = chatUser?.uid else {return}
        
        let document = FirebaseManager.shared.firestore
            .collection(Constants.COLLECTION.Messages)
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = [
            FirebaseConstants.fromId: fromId,
            FirebaseConstants.toId: toId,
            FirebaseConstants.text: chatText,
            "timestamp": Timestamp()
        ] as [String : Any]
        
        document.setData(messageData, completion: {
            err in
            if let err = err{
                self.errorMessage = "Failed to save message into Firestore: \(err)"
                return
            }
            self.persistRecentMessage()
            self.chatText = ""
            self.count += 1
        })
        
        
        let receiveMessageDocument = FirebaseManager.shared.firestore
            .collection(Constants.COLLECTION.Messages)
            .document(toId)
            .collection(fromId)
            .document()
        
        let receiveMessageData = [
            FirebaseConstants.fromId: toId,
            FirebaseConstants.toId: fromId,
            FirebaseConstants.text: chatText,
            FirebaseConstants.timestamp: Timestamp()
        ] as [String : Any]
        
        receiveMessageDocument.setData(receiveMessageData, completion: {
            err in
            if let err = err{
                self.errorMessage = "Failed to save message into Firestore: \(err)"
                return
            }
        })
    }
    
    private func persistRecentMessage(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = self.chatUser?.uid else {return}
        guard let chatUser = self.chatUser else {return}
        let document = FirebaseManager.shared.firestore
            .collection(Constants.COLLECTION.RecentMessage)
            .document(uid)
            .collection(Constants.COLLECTION.Messages)
            .document(toId)
        
        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
            FirebaseConstants.email: chatUser.email,
            
        ] as [String: Any]
        
        document.setData(data){ err in
            if let err = err{
                self.errorMessage = "Failed to save recent message: \(err)"
                return
            }
            
        }
    }
    
    
}
