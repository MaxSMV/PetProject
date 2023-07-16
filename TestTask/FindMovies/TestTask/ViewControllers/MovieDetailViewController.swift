//
//  MovieDetailViewController.swift
//  TestTask
//
//  Created by Max Stefankiv on 31.03.2023.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let padding = descriptionTextView.textContainer.lineFragmentPadding
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        
        if let movie = movie {
            titleLabel.text = movie.trackName
            yearLabel.text = movie.releaseDate
            genreLabel.text = movie.primaryGenreName
            descriptionTextView.text = movie.longDescription
            artworkImageView.image = nil
            
            URLSession.shared.dataTask(with: movie.artworkUrl500) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.artworkImageView.image = image
                    }
                }
            }.resume()
        }
    }

    @IBAction func onShareButtonClicked(_ sender: Any) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let textToShare = "This is the movie I was talking about:"

        if let myWebsite = movie?.trackViewUrl {//Enter link to your app here
            let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            //

            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
