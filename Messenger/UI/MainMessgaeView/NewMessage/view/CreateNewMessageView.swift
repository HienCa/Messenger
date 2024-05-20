//
//  CreateNewMessageView.swift
//  Messenger
//
//  Created by Nguyen Van Hien on 8/5/24.
//

import SwiftUI
import SDWebImageSwiftUI
struct CreateNewMessageView: View {
    let didSelectNewUser: (ChatUser) -> ()
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = CreateNewMessageViewModel()
    var body: some View {
        NavigationView{
            ScrollView{
                ForEach(viewModel.users){ user in
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    }, label: {
                        HStack(spacing: 16, content: {
                            WebImage(url: URL(string: user.profileImageUrl), content: {
                                        image in
                                        image.resizable().frame(width: CGFloat(50), height: CGFloat(50)).cornerRadius(44)
                                    }, placeholder: {
                                        Rectangle().foregroundColor(.gray)
                                    })
                                    .onSuccess { image, data, cacheType in
                                            
                                        }
                                        .indicator(.activity)
                                        .transition(.fade(duration: 0.5))
                                        .scaledToFill()
                                        .frame(width: CGFloat(50), height: CGFloat(50), alignment: .center)
                                        .clipped()
                                        .cornerRadius(50)
                                        .overlay(content: {
                                            RoundedRectangle(cornerRadius: 44)
                                                .stroke(Color(.white), lineWidth: 1)
                                        })
                                        .shadow(radius: 5)
                            
                            Text(user.email)
                            Spacer()
                        })
                        .padding(.horizontal)
                        
                        
                    })
                    Divider()
                        .padding(.vertical, 8)
                    
                }
         
            }
            .navigationTitle("New Message")
            .toolbar(content: {
                ToolbarItemGroup(placement: .navigation, content: {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                })
            })
        }
    }
}

#Preview {
    CreateNewMessageView(didSelectNewUser: { _ in })
}
