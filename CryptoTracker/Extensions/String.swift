//
//  String.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 11/03/24.
//

import Foundation

extension String {
    
    var removeHtmlOccurances : String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "" ,options: .regularExpression ,range: nil)
    }
}
