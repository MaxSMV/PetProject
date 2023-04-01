//
//  HomeViewController.swift
//  TestTask
//
//  Created by Max Stefankiv on 28.03.2023.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var movies: [Movie] = []
    private let favoritesService = FavoritesService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let searchText = searchTextField.text, !searchText.isEmpty else {
            return
        }
        
        searchMovies(query: searchText)
    }
    
    func searchMovies(query: String) {
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(query)&entity=movie") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard
                let self = self,
                let data = data
            else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(SearchResultDTO.self, from: data)
                let favoritesList = self.favoritesService.getIDs()

                DispatchQueue.main.async {
                    self.movies = result.results
                        .map { movieDTO in
                            let isFavorite = favoritesList.contains(movieDTO.trackId)
                            return Movie(dto: movieDTO, isFavorite: isFavorite)
                        }

                    self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCellIdentifier", for: indexPath) as! MovieTableViewCell
        
        let movie = movies[indexPath.row]
        cell.configure(with: movie, isFavorite: movie.isFavorite)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        let movieDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MovieDetailVC") as! MovieDetailViewController
        movieDetailVC.movie = selectedMovie
        self.present(movieDetailVC, animated: true, completion: nil)
    }
}
