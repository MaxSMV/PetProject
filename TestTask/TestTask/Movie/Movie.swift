//
//  Movie.swift
//  TestTask
//
//  Created by Max Stefankiv on 29.03.2023.
//

import Foundation

struct SearchResultDTO: Decodable {
    let resultCount: Int
    let results: [MovieDTO]
}

enum CodingKeys: String, CodingKey {
    case artworkUrl100, trackId, trackName, releaseDate, primaryGenreName, previewUrl, longDescription
}

// Data Transfer Object
struct MovieDTO: Decodable {
    var artworkUrl100: URL
    let trackId: Int
    let trackName: String
    var releaseDate: String
    var primaryGenreName: String
    let previewUrl: URL?
    let trackViewUrl: URL
    let longDescription: String
}

struct Movie {
    var artworkUrl500: URL {
        artworkUrl100
            .deletingLastPathComponent()
            .appendingPathComponent("500x500bb.jpg")
    }
    let artworkUrl100: URL
    let trackId: Int // add trackId
    let trackName: String
    let releaseDate: String
    let primaryGenreName: String
    let previewUrl: URL?
    let longDescription: String
    let isFavorite: Bool
    let trackViewUrl: URL

    init(dto: MovieDTO, isFavorite: Bool) {
        self.artworkUrl100 = dto.artworkUrl100
        self.trackId = dto.trackId
        self.trackName = dto.trackName
        self.primaryGenreName = dto.primaryGenreName
        self.previewUrl = dto.previewUrl
        self.trackViewUrl = dto.trackViewUrl
        self.longDescription = dto.longDescription

        self.releaseDate = Self.getFormattedDate(from: dto.releaseDate)

        self.isFavorite = isFavorite
    }

    private static func getFormattedDate(from isoString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = dateFormatter.date(from: isoString) else {
            return "invalid date"
        }
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
}
