//
//  MessageItem.swift
//  Messenger
//
//  Created by Nguyen Van Hien on 11/5/24.
//

import SwiftUI

struct MessageItem: View {
    let message: ChatMessage
    var body: some View {

        VStack{
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid{
                HStack{
                    Spacer()
                    HStack{
                        
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                
            }else{
                HStack{
                    Spacer()
                    HStack{
                        
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                }
                
            }
        }.padding()
            .padding(.top, 8)
    }
}

