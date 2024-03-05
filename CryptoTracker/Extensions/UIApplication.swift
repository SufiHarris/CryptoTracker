//
//  UIApplication.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 28/02/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing () {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
