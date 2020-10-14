//
//  MovieTableViewCell.swift
//  Movie App
//
//  Created by Denis Osmanovic on 10/9/20.
//  Copyright © 2020 Denis Osmanovic. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieDateLabel: UILabel!
    @IBOutlet var movieOverviewLabel: UILabel!
    @IBOutlet var moviePosterImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "MovieTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieTableViewCell", bundle: nil)
    }
    
    func configure(with model: Movie){
        self.movieTitleLabel.text = model.title
        self.movieDateLabel.text = model.release_date
        self.movieOverviewLabel.text = model.overview
        let url = model.poster_path
        let poster = "https://image.tmdb.org/t/p/w92" + url
        let data = URL(string: poster)!
        self.moviePosterImageView.load(url: data)
        
        
    }
    
}
extension UIImageView {
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
