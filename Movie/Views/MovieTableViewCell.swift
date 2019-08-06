//
//  MovieTableViewCell.swift
//  Movie
//
//  Created by Soni Suman on 8/6/19.
//  Copyright © 2019 devhubs. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

  @IBOutlet weak var movieImage: UIImageView!
  @IBOutlet weak var movieFormat: UILabel!
  @IBOutlet weak var movieRating: UserRating!
  @IBOutlet weak var movieTitle: UILabel!
  
  var userRatingHandlers: ((_ rating : Int) -> Void)? {
    didSet {
      if let ratingHandler = userRatingHandlers {
        movieRating.ratingHandler = ratingHandler
      }
    }
  }
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
  func configureCell(movie: Movie) {
    movieTitle.text = movie.title
    movieFormat.text = movie.format
    movieRating.rating = Int(movie.userRating)
    if let imageData = movie.image as Data? {
      movieImage.image = UIImage(data: imageData)
    }
  }

}
