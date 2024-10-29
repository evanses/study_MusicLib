//
//  InfoDetails.swift
//  ArtistLib
//
//  Created by eva on 29.10.2024.
//

import SwiftUI

struct InfoDetails: View {
    let artist: Artist
    @State var image = Image(systemName: "music.note")
    @State var artistDecsr: String = ""

    var body: some View {
        ScrollView {
            VStack {
                image
                    .resizable()
                    .frame(width: .infinity, height: 300)
                    .padding(50)
                    .shadow(radius: 10)
                Text("\(artist.name)")
                    .font(.largeTitle)
                Spacer()
                HStack {
                    Text("Прослушиваний: \(artist.playcount)")
                        .padding(.leading, 20)
                    Spacer()
                    Text("Слушателей: \(artist.listeners)")
                        .padding(.trailing, 20)
                }
                .padding()
                Text("Описание")
                    .font(.title3)
                Spacer()
                Text(artistDecsr)
                    .padding()
            }
        }
        .onAppear() {
            NetworkManager.shared.fetchArtistInfo(artistTitle: artist.name) { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let info):
                    self.artistDecsr = info.decsrc
                }
            }
            
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
        name: "Linkin Park",
        playcount: 2,
        listeners: 3,
        url: "sadasda",
        imageUrl: "https://lastfm.freetls.fastly.net/i/u/34s/2a96cbd8b46e442fc41c2b86b821562f.png"
    )
    
    InfoDetails(artist: artist)
}
