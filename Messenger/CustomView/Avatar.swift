//
//  Avatar.swift
//  Messenger
//
//  Created by Nguyen Van Hien on 8/5/24.
//
import SwiftUI
import SDWebImageSwiftUI
import Foundation
struct Avatar: View {
    let url: URL?
    let width: CGFloat
    let height: CGFloat

    init(url: URL?, width: CGFloat, height: CGFloat) {
        self.url = url
        self.width = width
        self.height = height
    }

    var body: some View {
        WebImage(url: url)
            .resizable()
//            .placeholder {
//                Rectangle().foregroundColor(.gray)
//            }
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFill()
            .frame(width: width, height: height)
            .clipped()
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 44)
                    .stroke(Color.white, lineWidth: 1)
            )
            .shadow(radius: 5)
    }
}
