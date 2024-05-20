//
//  MarqueeText.swift
//  Messenger
//
//  Created by Nguyen Van Hien on 13/5/24.
//

import Foundation
import SwiftUI
struct MarqueeText: View {
    let text: String
    @State private var offsetX: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            Text(text)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(.label))
                .offset(x: offsetX)
                .animation(Animation.linear(duration: 5).repeatForever(autoreverses: false))
                .onAppear {
                    let textWidth = geometry.size.width
                    let totalWidth = textWidth + geometry.size.width
                    withAnimation {
                        self.offsetX = -totalWidth
                    }
                }
        }
    }
}
