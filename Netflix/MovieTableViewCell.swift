//
//  MovieTableViewCell.swift
//  Netflix
//
//  Created by Slootmans Dwayne on 25/11/15.
//  Copyright © 2015 Tiny Rock Productions. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var imageViewPoster: UIImageView!
    
    var movie:Movie!

    @IBAction func favoriteButtonTapped(sender: UIButton) {
        if sender.imageView?.image == UIImage(named: "favorite_empty") {
            sender.setImage(UIImage(named: "favorite_full"), forState: UIControlState.Normal)
            NetflixDataManager.sharedManager.addFavorite(movie.title)
        } else {
            sender.setImage(UIImage(named: "favorite_empty"), forState: UIControlState.Normal)
            NetflixDataManager.sharedManager.removeFromFavorites(movie.title)
        }
    }
}