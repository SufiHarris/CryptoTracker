//
//  XmarkButton.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 29/02/24.
//

import SwiftUI

struct XmarkButton: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        } , label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

#Preview {
    XmarkButton()
}
