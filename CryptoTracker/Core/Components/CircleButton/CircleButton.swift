//
//  CircleButton.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 24/02/24.
//

import SwiftUI

struct CircleButton: View {
    let iconName : String
    var body: some View {
       Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(Color.theme.accent)
            .frame(width: 50 , height: 50)
            .background(
            Circle()
                .foregroundStyle(Color.theme.background)
            )
            .shadow(
                color: Color.theme.accent.opacity(0.25),
                radius: 10)
            .padding()
    }
}

#Preview {
    CircleButton(iconName: "info.circle")
        .previewLayout(.sizeThatFits)
}
