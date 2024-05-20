//
//  ChatLogView.swift
//  Messenger
//
//  Created by Nguyen Van Hien on 8/5/24.
//

import SwiftUI

struct ChatLogView: View {
    let chatUser: ChatUser?
    let emptyScrollToString = "Empty"
    
    init(chatUser: ChatUser?){
        self.chatUser = chatUser
        self.viewModel = .init(chatUser: chatUser)
    }
    @ObservedObject var viewModel: ChatViewModel
    var body: some View {
        NavigationView(content: {
            VStack{
                messageView
                chatBottomBar
            }.background(Color(.init(white: 0.95, alpha: 1)))

        })
    }
    
    private var messageView: some View{
        ScrollView{
            ScrollViewReader(content: { proxy in
                VStack{
                    ForEach(viewModel.chatMessages){ message in
                        MessageItem(message: message)
                    }
                    HStack{
                        Spacer()
                    }
                    .id(self.emptyScrollToString)
                    .onReceive(viewModel.$count, perform: { _ in
                        withAnimation(.easeInOut(duration: 0.5), {
                            proxy.scrollTo(self.emptyScrollToString, anchor: .bottom)
                        })
                        
                    })
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
            })
        }
        .navigationTitle(chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }

    
    private var chatBottomBar: some View{
        HStack(spacing: 16, content: {
           
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))

            TextField("Description", text: $viewModel.chatText).opacity(viewModel.chatText.isEmpty ? 0.5 : 1)
            Button(action: {
                if (viewModel.chatText != ""){
                    viewModel.handleSend()
                }
            }, label: {
                Text("Send")
                    .foregroundColor(.white)
            })
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(4)
        })
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    ChatLogView(chatUser: ChatUser(data: ["email": "vanhiena4@gmail.com", "uid": "hienca", "profileImageUrl": ""])!)
}
