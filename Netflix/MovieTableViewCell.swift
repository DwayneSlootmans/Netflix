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
    
    var movie:Movie!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func favoriteButtonTapped(sender: UIButton) {
        if sender.imageView?.image == UIImage(named: "favorite_empty") {
            sender.setImage(UIImage(named: "favorite_full"), forState: UIControlState.Normal)
            Favorite.addFavorite(movie.title)
        } else {
            sender.setImage(UIImage(named: "favorite_empty"), forState: UIControlState.Normal)
            Favorite.removeFromFavorites(movie.title)
        }
    }
}
