//
//  FavoritesViewController.swift
//  TestTask
//
//  Created by Max Stefankiv on 28.03.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    private var favorites: [Movie] = []
    private let favoriteService = FavoritesService()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        favoriteService.getMovies { [weak self] movies in
            guard let self = self else { return }
            self.favorites = movies
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCellIdentifier", for: indexPath) as! MovieTableViewCell
        
        let movie = favorites[indexPath.row]
        cell.configure(with: movie, isFavorite: true)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = favorites[indexPath.row]
        let movieDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MovieDetailVC") as! MovieDetailViewController
        movieDetailVC.movie = selectedMovie
        self.present(movieDetailVC, animated: true, completion: nil)
    }
}
