//
//  MainMessageView.swift
//  Messenger
//
//  Created by Nguyen Van Hien on 8/5/24.
//

import SwiftUI
import SDWebImageSwiftUI
struct MainMessageView: View {
    @State var shouldShowLogOutOptions: Bool = false
    @State var shouldNavigationToChatLogView: Bool = false
    @ObservedObject private var viewModel = MainMessageViewModel()
    @State var chatUser: ChatUser?
    var body: some View {
        NavigationView{
            VStack{
                customnavBar
                messagesView
                NavigationLink(
                    destination: ChatLogView(chatUser: self.chatUser),
                    isActive: $shouldNavigationToChatLogView,
                    label: { Text("Navigate") }
                )

               
                
            }
            .overlay(alignment: .bottom, content: {
                newMessageButton
            })
            .navigationBarBackButtonHidden(true)
            
        }
    }
    
    private var customnavBar: some View{
        HStack(spacing: 16, content: {
            
            WebImage(url: URL(string: viewModel.chatUser?.profileImageUrl ?? ""), content: {
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
            
            VStack(alignment: .leading, spacing: 4, content: {
              
                Text("\(viewModel.chatUser?.email ?? "")")
                    .font(.system(size: 16, weight: .bold))
                
                HStack{
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                    
                }
            })
            Spacer()
            Button(action: {
                self.shouldShowLogOutOptions.toggle()
            }, label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            })
        })
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions, content: {
            .init(title: Text("Settings"),
                  message: Text("What do you want to do?"),
                  buttons: [
                    .destructive(Text("Sign Out"), action: {
                        print("handle sign out")
                        viewModel.handleSignOut()
                    }),
                    .cancel()
                  ])
        })
        .fullScreenCover(isPresented: $viewModel.isUserCurrentlyLoggedOut, onDismiss: nil, content: {
            Authentication(didCompleteLoginProgress: {
                self.viewModel.isUserCurrentlyLoggedOut = false
                self.viewModel.fetchCurrentUser()
            })
        })
    }
    
    private var messagesView: some View{
        ScrollView{
            ForEach(viewModel.recentMessages){
                recentMessage in
                VStack{
                    NavigationLink(destination: {
                        
                    }, label: {
                        HStack(spacing: 16, content: {
                            WebImage(url: URL(string: recentMessage.profileImageUrl), content: {
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
                                                .stroke(Color(.black), lineWidth: 1)
                                        })
                                        .shadow(radius: 5)

                            
                            VStack(alignment: .leading, spacing: 8, content: {
                                Text(recentMessage.email.components(separatedBy: "@").first ?? "")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(.label))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Text(recentMessage.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.darkGray))
                                    .multilineTextAlignment(.leading)
                            })
                            Spacer()
                            Text("\(Utils.formatTimestamp(recentMessage.timestamp))")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(.label))
                        })
                        Divider()
                            .padding(.vertical, 8)
                    })
                    
                }
                .padding()
            }
            .padding(.horizontal)
        }
        .padding(.bottom,50)
    }
    
    @State var shouldShowNewMessageScreen = false
    private var newMessageButton: some View{
        Button(action: {
            shouldShowNewMessageScreen.toggle()
        }, label: {
            HStack{
                Spacer()
                Text("+ New Message")
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        })
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen, onDismiss: nil, content: {
            CreateNewMessageView(didSelectNewUser: { user in
                self.shouldNavigationToChatLogView.toggle()
                self.chatUser = user
            })
        })
    }
}

#Preview {
    MainMessageView()
        .preferredColorScheme(.dark)
    
}
