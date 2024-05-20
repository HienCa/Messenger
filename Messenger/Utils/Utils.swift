//
//  Utils.swift
//  Messenger
//
//  Created by Nguyen Van Hien on 8/5/24.
//

import Foundation
import SDWebImageSwiftUI
import SwiftUI
import Firebase
class Utils{
    static func formatTimestamp(_ timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
        
        return dateFormatter.string(from: date)
    }
}


