//
//  ContentView.swift
//  ArtistLib
//
//  Created by eva on 29.10.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var artists = [Artist]()
    var titleOn: Bool

    var body: some View {
        NavigationView {
            List() {
                if titleOn {
                    Section() {
                        Text("ТОП Артистов")
                    }
                }
                ForEach(artists, id: \.id) { artist in
                    NavigationLink {
                        InfoDetails(artist: artist)
                    } label: {
                        ArtistRowView(artist: artist)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .task {
                fetchArtists()
            }
        }
    }
    
    private func fetchArtists() {
        NetworkManager.shared.fetchArtistChart { result in
            switch result {
            case .success(let fetchedArtists):
                self.artists = fetchedArtists.sorted(by: { $0.id < $1.id })
            case .failure(let error):
                print(error)
            }
        }

    }
}

#Preview {
    @State var t: Bool = false
    ContentView(titleOn: t)
}
