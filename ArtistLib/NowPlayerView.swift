//
//  NowPlayerView.swift
//  ArtistLib
//
//  Created by eva on 29.10.2024.
//

import SwiftUI
import AVFoundation
import AVFAudio

struct PlayerView: View {
    let song: NavidromeSong
    @Binding var isPlaying: Bool
    @State var player: AVPlayer?
    
    var body: some View {
        HStack {
            Button {
                isPlaying.toggle()
                
                if isPlaying  {
                    self.player?.play()
                } else {
                    player?.pause()
                    player?.seek(to: .zero)
                }

            } label: {
                if isPlaying {
                    Image(systemName: "pause.circle")
                        .resizable()
                        .foregroundStyle(.gray)
                        .scaledToFit()
                        .frame(width: 70)
                } else {
                    Image(systemName: "play.circle")
                        .resizable()
                        .foregroundStyle(.gray)
                        .scaledToFit()
                        .frame(width: 70)
                }
            }
        
            VStack {
                PlayerLineView(song: song, isPlaying: $isPlaying)
                Text("\(song.duration/60):\(song.duration-((song.duration/60)*60))")
            }
        }
        .onAppear() {
            guard let url = URL(string: "https://mus.hiix.ru/rest/stream.view?u=testUserok&p=asdasdcwevcwefefwedcd&v=1.15&c=iosApp&id=\(song.id)") else { return }
            let playerItem = AVPlayerItem(url: url)
            self.player = AVPlayer(playerItem: playerItem)
        }
    }
}

struct PlayerLineView: View {
    let song: NavidromeSong
    @Binding var isPlaying: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(.systemGray4))
                .frame(width: 200, height: 6)
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(.orange))
                .frame(width: 10, height: 8)
                .offset(x: isPlaying ? 95 : -95, y: 0)
                .animation(
                    isPlaying ? .linear(duration: Double(song.duration)) : .bouncy,
                    value: isPlaying
                )
        }
    }
}

struct NowPlayerView: View {
    let currentSong: NavidromeSong?
    @State var image = Image(systemName: "music.note")
    @State var isPlaying: Bool = false
    @State private var angle: Double = 0

    var body: some View {
        if let song: NavidromeSong = currentSong {
            ScrollView {
                VStack {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .cornerRadius(150)
                        .padding(.top, 25)
                        .shadow(radius: 10)
                        .rotationEffect(.degrees(isPlaying ? 0 : 360))
                        .animation(
                            isPlaying ? .linear(duration: Double(song.duration)) : .bouncy,
                            value: isPlaying
                        )
                    
                    PlayerView(song: song, isPlaying: $isPlaying)
                    
                    Text(song.title)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                    Text(song.artist)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                    Text("Альбом: \(song.album)")
                        .multilineTextAlignment(.center)
                    if let year:Int = song.year {
                        Text("Год: \(year)")
                            .font(.caption)
                    }
                }
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
        } else {
            Text("Вы не выбрали трек из библиотеки!")
        }
    }
}

#Preview {
    let song = NavidromeSong(
        id: "434725b2ed9ddaaacaf9b67632ab247f",
        parent: "sadasd",
        title: "The Emptiness Machine",
        album: "The Emptiness Machine",
        artist: "Linkin Park",
        year: 2024,
        coverArt: "al-ffd9cc85e7e1b8c64a5d967abdaf1e09",
        duration: 186
    )
    
    NowPlayerView(currentSong: song)
}
