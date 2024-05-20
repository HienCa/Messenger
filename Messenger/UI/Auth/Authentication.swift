//
//  Authentication.swift
//  Messenger
//
//  Created by Nguyen Van Hien on 7/5/24.
//

import SwiftUI
import Firebase
struct Authentication: View {
    let didCompleteLoginProgress: () -> ()
    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @State private var message = ""
    @State private var shouldShowImagePicker = false
    @State private var image = UIImage()
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    Picker(selection: $isLoginMode, content: {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }, label: {
                        Text("Log In")
                    }).pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode{
                        Button(action: {
                            shouldShowImagePicker.toggle()
                        }, label: {
                            VStack{
                                if self.image != UIImage() {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 128, height: 128)
                                        .scaledToFill()
                                        .cornerRadius(64)
                                }else{
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64).stroke(Color.black, lineWidth: 3))
                        })
                    }
                    Spacer(minLength: 20)
                    Group{
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                        
                    }
                    .padding(12)
                    .background(Color.white)
                    
                    Spacer(minLength: 20)
                    
                    Button(action: {
                        handleAction()
                    }, label: {
                        HStack{
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }
                        .background(Color.blue)
                        
                    })
                    
                    Text(message)
                        .foregroundColor(.red)
                    
                }.padding()
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(Color.init(white: 0, opacity: 0.05))
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker ,onDismiss: nil, content: {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        })
    }
    
    private func handleAction(){
        if isLoginMode{
            loginUser()
        }else{
            createNewAccount()
        }
    }
    
    private func loginUser(){
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password){
            result, err in
            if let err = err{
                print("Failed to create user: ", err)
                self.message = "Failed to login"
                return
            }
            self.message = "Successfully login!"
            self.didCompleteLoginProgress()

        }
    }
    
    private func createNewAccount(){
        if self.image == nil{
            self.message = "You must select an avatar image."
            return
        }
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password){
            result, err in
            if let err = err{
                print("Failed to create user: ", err)
                self.message = "Failed to create user: \(err)"
                return
            }
            self.message = "Successfully created user: \(result?.user.uid ?? "")"
            self.persistImageStorage()
        }
    }
    
    private func persistImageStorage(){
//        let filename = UUID().uuidString
        guard let uid =  FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let imageData = self.image.jpegData(compressionQuality: 0.5) else {return}
        
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        ref.putData(imageData, metadata: nil){
            metadata, err in
            if let err = err{
                self.message = "Failed to push image to Storage: \(err)"
                return
            }
            
            ref.downloadURL{
                url, err in
                if let err = err{
                    self.message = "Failed to retrieve dowloadURL: \(err)"
                    return
                }
                self.message = "Successfully storaged image with url: \(url?.absoluteString ?? "")"
                
                guard let url = url else {return}
                self.storeUserInformation(profileImageUrl: url)
            }
        }
    }
    
    private func storeUserInformation(profileImageUrl: URL){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": profileImageUrl.absoluteString]
        FirebaseManager.shared.firestore.collection(Constants.COLLECTION.User)
            .document(uid).setData(userData, completion: {
                err in
                if let err = err {
                    self.message = "\(err)"
                    return
                }
                self.message = "Success"
                self.didCompleteLoginProgress()
            })
    }
}

#Preview {
    Authentication(didCompleteLoginProgress: {
        
    })
}
