//
//  ArtistRowView.swift
//  ArtistLib
//
//  Created by eva on 29.10.2024.
//

import SwiftUI

struct ArtistRowView: View {
    let artist: Artist
    @State var image = Image(systemName: "music.note")
    
    var body: some View {
        HStack {
            image
                .resizable()
                .frame(width: 80, height: 70)
                .padding(.leading, 30)
                .shadow(radius: 10)
            Spacer()
            Text("\(artist.name)")
                .font(.headline)
            Spacer()
        }
        .onAppear() {
            NetworkManager.shared.fetchImage(url: artist.imageUrl) { result in
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
    let artist = Artist(
        id: 0,
        name: "Test name",
        playcount: 2,
        listeners: 3,
        url: "sadasda",
        imageUrl: "https://lastfm.freetls.fastly.net/i/u/34s/2a96cbd8b46e442fc41c2b86b821562f.png"
    )
    ArtistRowView(artist: artist)
}
