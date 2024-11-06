//
//  TabRootView.swift
//  ArtistLib
//
//  Created by eva on 29.10.2024.
//

import SwiftUI

struct TabRootView: View {
    @State private var tabSelection = 0
    @State var currentSong: NavidromeSong?
    @AppStorage("titleOn") var titleOn: Bool = true
    
    var body: some View {
        TabView(selection: $tabSelection) {
            ContentView(selectedSong: $currentSong, tabSelection: $tabSelection, titleOn: titleOn)
                .tabItem {
                    Label("Library", systemImage: "music.note.list")
                }
                .tag(0)
            NowPlayerView(currentSong: currentSong)
                .tabItem {
                    Label("Player", systemImage: "play.circle")
                }
                .tag(1)
            SettingsView(titleOn: $titleOn)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
            }
    }
}

#Preview {
    TabRootView()
}
