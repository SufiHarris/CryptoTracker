//
//  SearchBar.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 28/02/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var textfieldText : String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(textfieldText.isEmpty ? Color.theme.secondaryText : Color.theme.accent)
            TextField("Search by name or symbol...", text: $textfieldText)
                .foregroundStyle(Color.theme.accent)
                .autocorrectionDisabled(true)
                .overlay (
                    Image(systemName: "multiply.circle")
                        .padding()
                        .foregroundStyle(Color.theme.accent)
                        .opacity(textfieldText.isEmpty ? 0.0 : 1.0)
                    ,alignment: .trailing
                )
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    textfieldText = ""
                }
        }
        .font(.headline)
        .padding()
        .background(
          Rectangle()
            .fill(Color.theme.background)
            .cornerRadius(25)
            .shadow(color : Color.theme.accent.opacity(0.25),radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    
        )
        .padding()
    

    }
}

#Preview {
    SearchBar(textfieldText: .constant(""))
}
