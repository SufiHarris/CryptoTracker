//
//  HapticManager.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 05/03/24.
//

import Foundation
import SwiftUI

class HapticManager {
    
    static let generator = UINotificationFeedbackGenerator()
    static func notification (type : UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    
}
