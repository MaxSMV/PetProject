//
//  MovieTableViewCell.swift
//  TestTask
//
//  Created by Max Stefankiv on 29.03.2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var movie: Movie?
    private let favoritesService = FavoritesService()
    
    func configure(with movie: Movie, isFavorite: Bool) {
        self.movie = movie
        titleLabel.text = movie.trackName
        yearLabel.text = movie.releaseDate
        genreLabel.text = movie.primaryGenreName
        artworkImageView.image = nil
        favoriteButton.isSelected = isFavorite
        
        URLSession.shared.dataTask(with: movie.artworkUrl500) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.artworkImageView.image = image
                }
            }
        }.resume()
    }
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let movie = movie else {
            return
        }
        
        if favoriteButton.isSelected {
            favoritesService.remove(trackId: movie.trackId)
        } else {
            favoritesService.add(movieId: movie.trackId)
        }
        
        favoriteButton.isSelected.toggle()
    }
}
