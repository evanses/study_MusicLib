//
//  NetworkManager.swift
//  ArtistLib
//
//  Created by eva on 29.10.2024.
//

import Foundation
import SwiftUI

final class NetworkManager {
    private let apiKey = "b29785239bb6bb36d0bb12e3f068eea6"
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchArtistInfo(artistTitle: String, completion: @escaping ((Result<ArtistInfo, NetworkError>) -> Void)) {
        let uri = "https://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=\(artistTitle)&api_key=\(self.apiKey)&format=json"
        
        guard let url = URL(string: uri) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print(error)
                completion(.failure(.notInternet))
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                completion(.failure(.responseError))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                
                struct ApiArtistBio: Codable {
                    let content: String
                }
                
                struct ApiArtistInfo: Codable {
                    let bio: ApiArtistBio
                }
                
                struct ApiArtist: Codable {
                    let artist: ApiArtistInfo
                }
                
                let res = try decoder.decode(ApiArtist.self, from: data)
                
                let artistInfo = ArtistInfo(decsrc: res.artist.bio.content)
                
                completion(.success(artistInfo))
            } catch {
                print(error)
                
                completion(.failure(.parsingError))
            }
            
        }.resume()
    }
    
    func fetchImage(coverArt: String, completion: @escaping ((Result<Image, NetworkError>) -> Void)) {
        let imageUri = "https://mus.hiix.ru/rest/getCoverArt.view?u=testUserok&p=asdasdcwevcwefefwedcd&v=1.15&c=iosApp&id=\(coverArt)"
        
        guard let imageUrl = URL(string: imageUri) else {
//            print("when fetching image, url is not valid")
            completion(.failure(.urlNotValid))
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let error {
//                print("when fetching image, there is no internet")
                completion(.failure(.notInternet))
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
//                print("when fetching image, response status code is not 200")
                completion(.failure(.responseError))
                return
            }
            
            guard let data else {
//                print("when fetching image, there is no data")
                completion(.failure(.noData))
                return
            }
            
            guard let uiImage = UIImage(data: data) else {
//                print("when fetching image, there is no data2 (in UIImage")
                completion(.failure(.noData))
                return
            }
//            print("done fetching image ")
            completion(.success(Image(uiImage: uiImage)))
        }.resume()
    }
    
    func fetchArtistsList(completion: @escaping ((Result<[Artist], NetworkError>) -> Void)) {
        let uri = "https://mus.hiix.ru/rest/getArtists.view?u=testUserok&p=asdasdcwevcwefefwedcd&v=1.12.0&c=iosApp&f=json"
        
        guard let url = URL(string: uri) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data,
            response,
            error in
            
            if let error {
                completion(.failure(.notInternet))
//                print("when fetching artists list, not internet")
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
//                print("when fetching artists list, response status code is not 200")
                completion(.failure(.responseError))
                return
            }
            
            guard let data else {
//                print("when fetching artists list, no data")
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let res = try decoder.decode(NavidroveMainResponse.self, from: data)
                
                var artists = [Artist]()
                
                var countId = 0
                
                res.subsonicResponse.artists.index.forEach { i in
                    i.artist.forEach { artist in
                        let fetchedArtist = Artist(
                            id: countId,
                            name: artist.name,
                            albumCount: artist.albumCount,
                            imageId: artist.coverArt
                        )
                        countId += 1
                        artists.append(fetchedArtist)
                    }
                }
//                print("getting from requests:")
//                print(artists)
                completion(.success(artists))
                
            } catch (let error) {
                print(error)
                
                completion(.failure(.parsingError))
            }
            
        }.resume()
    }
    
    func fetchRandomSongs(completion: @escaping ((Result<[NavidromeSong], NetworkError>) -> Void)) {
        let uri = "https://mus.hiix.ru/rest/getPlaylist.view?u=testUserok&p=asdasdcwevcwefefwedcd&v=1.15&c=iosApp&f=json&id=91e1a119-ba60-4335-a196-b7266a09ad6d"
        
        guard let url = URL(string: uri) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data,
            response,
            error in
            
            if let error {
                completion(.failure(.notInternet))
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                completion(.failure(.responseError))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                struct SongResponse: Codable {
                    let entry: [NavidromeSong]
                }
                
                struct SecondRepsonse: Codable {
                    let playlist: SongResponse
                }
                
                struct MainResponse: Codable {
                    let response: SecondRepsonse
                    
                    private enum CodingKeys: String, CodingKey {
                        case response = "subsonic-response"
                    }
                }
                
                let decoder = JSONDecoder()
                let res = try decoder.decode(MainResponse.self, from: data)
                completion(.success(res.response.playlist.entry))
            } catch (let error) {
                print(error)
                completion(.failure(.parsingError))
            }
        }.resume()
    }
    
////    func fetchRandomSongs(completion: @escaping ((Result<[NavidromeSong], NetworkError>) -> Void)) {
////        let uri = "https://mus.hiix.ru/rest/getRandomSongs.view?u=testUserok&p=asdasdcwevcwefefwedcd&v=1.15&c=iosApp&f=json"
////        
////        guard let url = URL(string: uri) else {
////            return
////        }
////        
////        URLSession.shared.dataTask(with: url) {
////            data,
////            response,
////            error in
////            
////            if let error {
////                completion(.failure(.notInternet))
////                print(error.localizedDescription)
////                return
////            }
////            
////            if let response = response as? HTTPURLResponse,
////               response.statusCode != 200 {
////                completion(.failure(.responseError))
////                return
////            }
////            
////            guard let data else {
////                completion(.failure(.noData))
////                return
////            }
////            
////            do {                
////                struct SongResponse: Codable {
////                    let song: [NavidromeSong]
////                }
////                
////                struct SecondRepsonse: Codable {
////                    let status: String
////                    let randomSongs: SongResponse
////                }
////                
////                struct MainResponse: Codable {
////                    let response: SecondRepsonse
////                    
////                    private enum CodingKeys: String, CodingKey {
////                        case response = "subsonic-response"
////                    }
////                }
////                
////                let decoder = JSONDecoder()
////                let res = try decoder.decode(MainResponse.self, from: data)
////                completion(.success(res.response.randomSongs.song))
////            } catch (let error) {
////                print(error)
////                completion(.failure(.parsingError))
////            }
////        }.resume()
//    }
}
