//
//  ContentView.swift
//  ArtistLib
//
//  Created by eva on 29.10.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var artists = [Artist]()

    var body: some View {
        NavigationView {
            List(artists, id: \.id){ artist in
                NavigationLink {
                    InfoDetails(artist: artist)
                } label: {
                    ArtistRowView(artist: artist)
                }
            }
            .onAppear {
                fetchArtists()
            }
        }
    }
    
    private func fetchArtists() {
        NetworkManager.shared.fetchArtistChart { result in
            switch result {
            case .success(let fetchedArtists):
                DispatchQueue.main.async {
                    self.artists = fetchedArtists.sorted(by: { $0.id < $1.id })
                }
            case .failure(let error):
                print(error)
            }
        }

    }
}

#Preview {
    ContentView()
}
