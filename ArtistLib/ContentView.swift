//
//  ContentView.swift
//  ArtistLib
//
//  Created by eva on 29.10.2024.
//

import SwiftUI

struct ContentView: View {
    @Binding var selectedSong: NavidromeSong?
    @Binding var tabSelection: Int
    @State private var songs = [NavidromeSong]()
    var titleOn: Bool

    var body: some View {
        NavigationView {
            List() {
                if titleOn {
                    Section() {
                        Text("Случайные треки")
                    }
                }
                ForEach(songs, id: \.id) { song in
//                    NavigationLink {
//                        InfoDetails(song: song)
//                    } label: {
//                        SongRowView(song: song)
//                    }
                    SongRowView(song: song)
                        .onTapGesture {
                            print("tapped")
                            selectedSong = song
                            tabSelection = 1
                        }
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .task {
                fetchRandomSongs()
            }
        }
    }
    
    private func fetchRandomSongs() {
        NetworkManager.shared.fetchRandomSongs { result in
            switch result {
            case .success(let fetchedSongs):
                self.songs = fetchedSongs
            case .failure(let error):
                print(error)
            }
        }
    }
}

#Preview {
    @State var tabSelection = 1
    @State var selectedSong: NavidromeSong? = nil
    ContentView(selectedSong: $selectedSong, tabSelection: $tabSelection, titleOn: true)
}
