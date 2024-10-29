//
//  TabRootView.swift
//  ArtistLib
//
//  Created by eva on 29.10.2024.
//

import SwiftUI

struct TabRootView: View {
    
    var body: some View {
        TabView() {
            ContentView()
                .tabItem {
                    Label("Artists", systemImage: "music.note.list")
                }
            HelloView()
                .tabItem {
                    Label("Hello World", systemImage: "questionmark.circle")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    TabRootView()
}
