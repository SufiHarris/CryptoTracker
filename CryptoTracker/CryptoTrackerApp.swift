//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 24/02/24.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {
    @StateObject private var vm = HomeViewModel()
    @State var showLaunch : Bool = true
    init () {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    }
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
                    HomeView()
                }
                .environmentObject(vm)
                ZStack {
                    if showLaunch {
                        LaunchView(show: $showLaunch)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}

