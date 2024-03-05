//
//  LaunchView.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 12/03/24.
//

import SwiftUI

struct LaunchView: View {
    @State private var loadingText : [String] = "Loading your portfolio ...".map{String($0)}
    @State private var showLoading : Bool = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var counter  : Int = 0
    @State private var loops  : Int = 0
    @Binding  var show  : Bool
    var body: some View {
        ZStack {
            Color.launchBackground.ignoresSafeArea()
                Image("logo-transparent")
                .resizable()
                .frame(width: 100 , height: 100)
            ZStack {
                if showLoading {
//                    Text("\(loadingText)")
                     
//                        .transition(AnyTransition.scale.animation(.easeIn))
                    HStack (spacing : 0){
                        ForEach(loadingText.indices) { index in
                             Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundStyle(Color.launchAccent)
                                .offset(y : counter == index ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
            }
            .offset(y:70)
            
        }
        .onAppear {
            showLoading.toggle()
        }
        .onReceive(timer, perform: { _ in
            withAnimation(.spring()) {
                let last  = loadingText.count - 1
                
                if counter  == last {
                    counter = 0
                    loops += 1
                    
                    if loops >= 2 {
                        show = false
                    }
                } else {
                    counter += 1
                }
            }
        })
    }
}

#Preview {
    LaunchView( show : .constant(true))
}
