//
//  TabRootView.swift
//  ArtistLib
//
//  Created by eva on 29.10.2024.
//

import SwiftUI

struct TabRootView: View {
    @AppStorage("titleOn") var titleOn: Bool = true
    
    var body: some View {
        TabView() {
            ContentView(titleOn: titleOn)
                .tabItem {
                    Label("Artists", systemImage: "music.note.list")
                }
            HelloView()
                .tabItem {
                    Label("Hello World", systemImage: "questionmark.circle")
                }
            SettingsView(titleOn: $titleOn)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            }
    }
}

#Preview {
    TabRootView()
}
