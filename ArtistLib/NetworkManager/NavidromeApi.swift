//
//  NavidromeApi.swift
//  ArtistLib
//
//  Created by eva on 06.11.2024.
//

struct NavidromeSong: Codable {
    let id: String
    let parent: String
    let title: String
    let album: String
    let artist: String
    let year: Int?
    let coverArt: String
    let duration: Int
}

struct NavidromeArtist: Codable {
    let id: String
    let name: String
    let albumCount: Int
    let coverArt: String
    let artistImageUrl: String
}

struct NavidromeArtistsSecondResponse: Codable {
    let name: String
    let artist: [NavidromeArtist]
}

struct NavidromeArtistsResponse: Codable {
    let index: [NavidromeArtistsSecondResponse]
}

struct NavidromeSecondRepsonse: Codable {
    let status: String
    let artists: NavidromeArtistsResponse
}

struct NavidroveMainResponse: Codable {
    let subsonicResponse: NavidromeSecondRepsonse
    
    private enum CodingKeys: String, CodingKey {
        case subsonicResponse = "subsonic-response"
    }
}
