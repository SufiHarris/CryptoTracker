//
//  SettingsView.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 12/03/24.
//

import SwiftUI

struct SettingsView: View {
    let defaultUrl =  URL(string: "https://google.com")!
    let coinGecko =  URL(string: "https://google.com")!
    let personalUrl =  URL(string: "https://google.com")!
    let swiftfullThinking =  URL(string: "https://google.com")!
    
    var body: some View {
        NavigationStack {
            List {
                swiftfullSection
                coinGeckoSection
                devloper
                condition
            }
            .font(.headline)
            .tint(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    XmarkButton()
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}


extension SettingsView {
    private var swiftfullSection : some View  {
        
        Section {
            VStack (alignment: .leading , spacing: 10 , content: {
                Image("logo")
                    .resizable()
                    .frame(width: 80 , height: 80 )
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                Text("This project was created by following a course on @swiftfull thinking")
                
                Link("Check the course", destination: swiftfullThinking)
                Link("Help him with his coffee addiction ", destination: swiftfullThinking)
            })
            .padding(.vertical)
            .font(.callout)
        } header: {
        Text("Swiftfull Thinking")
        }
    }
    
    private var coinGeckoSection : some View  {
        
        Section {
            VStack (alignment: .leading , spacing: 10 , content: {
                Image("coingecko")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .frame(height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                Text("This project by using coin gecko free api's . The data might be slightly slow")
                
                Link("Check their link", destination: swiftfullThinking)
            })
            .padding(.vertical)
            .font(.callout)
        } header: {
        Text("CoinGecko API'S")
        }
    }
    
    private var devloper : some View  {
        
        Section {
            VStack (alignment: .leading , spacing: 10 , content: {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 100 , height: 100 )
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .foregroundStyle(.greenColors)
                Text("My name is harris and i am ios and react front end devloper .... ")
                
                Link("Check my portfolio !!!", destination: swiftfullThinking)
            })
            .padding(.vertical)
            .font(.callout)
        } header: {
        Text("Devloper")
        }
    }
    
    
    private var condition : some View  {
        
        Section {
        Link("Terms & Conditions", destination: defaultUrl)
        Link("Company Policy", destination: defaultUrl)
        Link("Devloper Conditions", destination: defaultUrl)
         
        } header: {
        Text("Terms and condition")
        }
    }
}
