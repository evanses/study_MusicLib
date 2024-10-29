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
    
    func fetchImage(url: String, completion: @escaping ((Result<Image, NetworkError>) -> Void)) {
        guard let imageUrl = URL(string: url) else {
            completion(.failure(.urlNotValid))
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
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
            
            DispatchQueue.main.async {
                guard let uiImage = UIImage(data: data) else {
                    completion(.failure(.noData))
                    return
                }
                completion(.success(Image(uiImage: uiImage)))
            }
        }.resume()
    }

    func fetchArtistChart(completion: @escaping ((Result<[Artist], NetworkError>) -> Void)) {
        let uri = "https://ws.audioscrobbler.com/2.0/?method=chart.gettopartists&api_key=\(self.apiKey)&format=json"
        
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
                let decoder = JSONDecoder()
                
                struct ApiResponseMain: Codable {
                    let artists: ApiResponseSecond
                }
                
                struct ApiResponseSecond: Codable {
                    let artist: [ApiArtist]
                }
                
                struct ApiArtistImage: Codable {
                    let url: String
                    let size: String
                    
                    private enum CodingKeys: String,
                                             CodingKey {
                        case url = "#text"
                        case size
                    }
                }
                
                struct ApiArtist: Codable {
                    let name: String
                    let playcount: String
                    let listeners: String
                    let url: String
                    let image: [ApiArtistImage]
                }
                
                let res = try decoder.decode(ApiResponseMain.self, from: data)
                
                var artists = [Artist]()
                
                var countId = 0
                
                for artist in res.artists.artist {
                    let fetchedArtist = Artist(
                        id: countId,
                        name: artist.name,
                        playcount: Int(artist.playcount) ?? 0,
                        listeners: Int(artist.listeners) ?? 0,
                        url: artist.url,
                        imageUrl: artist.image[0].url
                    )
                    countId += 1
                    
                    artists.append(fetchedArtist)
                }
                completion(.success(artists))
                
            } catch (let error) {
                print(error)
                
                completion(.failure(.parsingError))
            }
            
        }.resume()
    }
}
