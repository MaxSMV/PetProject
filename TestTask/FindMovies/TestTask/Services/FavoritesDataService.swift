//
//  FavoritesDataService.swift
//  TestTask
//
//  Created by Max Stefankiv on 31.03.2023.
//

import Foundation

struct FavoritesService {
    private enum Constants {
        static let FavoritesKey = "Favorites"
    }

    private let defaults = UserDefaults.standard

    // For the real API you would send POST request to the backend here.
    // And then GET request to get Favorites in any other place.
    func add(movieId: Int) {
        var favorites = getIDs()
        favorites.append(movieId)
        save(favorites: favorites)
    }
    
    func remove(trackId: Int) {
        var favorites = getIDs()
        favorites.removeAll(where: { $0 == trackId })
        save(favorites: favorites)
    }
    
    func isFavorite(trackId: Int) -> Bool {
        let favorites = getIDs()
        return favorites.contains(where: { $0 == trackId })
    }
    
    func getIDs() -> [Int] {
        if let data = defaults.data(forKey: Constants.FavoritesKey) {
            do {
                let decoder = JSONDecoder()
                let favorites = try decoder.decode([Int].self, from: data)
                return favorites
            } catch {
                print("Error decoding favorites: \(error)")
            }
        }
        return []
    }

    func getMovies(_ completion: @escaping ([Movie]) -> ()) {
        let favorites = getIDs()

        let ids = favorites
            .map { String(describing: $0) }
            .joined(separator: ",")

        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(ids)") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data
            else {
                return
            }

            do {
                let result = try JSONDecoder().decode(SearchResultDTO.self, from: data)
                let movies = result.results
                    .map { movieDTO in
                        Movie(dto: movieDTO, isFavorite: true)
                    }
                DispatchQueue.main.async {
                    completion(movies)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    private func save(favorites: [Int]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favorites)
            defaults.set(data, forKey: Constants.FavoritesKey)
        } catch {
            print("Error encoding favorites: \(error)")
        }
    }
}
