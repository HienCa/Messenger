//
//  ContentView.swift
//  Messenger
//
//  Created by Nguyen Van Hien on 7/5/24.
//

import SwiftUI
import Firebase
struct ContentView: View {
    
    var body: some View {
        
//        if (FirebaseManager.shared.currentUser == nil){
//            Authentication()
//        }else{
//            Button(action: {
//                
//            }, label: {
//                Text("Sign Out")
//            })
//        }
        Authentication(didCompleteLoginProgress: {})
    }
    
   
}

#Preview {
    ContentView()
}
