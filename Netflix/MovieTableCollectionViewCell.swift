//
//  MovieTableCollectionViewCell.swift
//  Netflix
//
//  Created by Slootmans Dwayne on 26/11/15.
//  Copyright © 2015 Tiny Rock Productions. All rights reserved.
//

import UIKit

class MovieTableCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    
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
