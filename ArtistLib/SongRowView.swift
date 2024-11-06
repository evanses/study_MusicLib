//
//  ArtistRowView.swift
//  ArtistLib
//
//  Created by eva on 29.10.2024.
//

import SwiftUI

struct SongRowView: View {
    let song: NavidromeSong
    @State var image = Image(systemName: "music.note")
    
    var body: some View {
        HStack {
            image
                .resizable()
                .frame(width: 80, height: 70)
                .cornerRadius(40)
                .padding(.leading, 30)
                .shadow(radius: 10)
            Spacer()
            VStack {
                Text(song.title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Text(song.artist)
                    .font(.caption)
            }
            Spacer()
        }
        .task {
            NetworkManager.shared.fetchImage(coverArt: song.coverArt) { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let fetchedImage):
                    self.image = fetchedImage
                }
            }
        }
    }
}

#Preview {
    let song = NavidromeSong(
        id: "sadasd",
        parent: "sadasd",
        title: "Song Name",
        album: "Album Name",
        artist: "Artist Name",
        year: 1998,
        coverArt: "al-ffd9cc85e7e1b8c64a5d967abdaf1e09",
        duration: 345
    )
    SongRowView(song: song)
}
