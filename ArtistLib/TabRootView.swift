//
//  TabRootView.swift
//  ArtistLib
//
//  Created by eva on 29.10.2024.
//

import SwiftUI

struct TabRootView: View {
    @Binding var titleOn: Bool 
    
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
    @State var t: Bool = true
    TabRootView(titleOn: $t)
}
