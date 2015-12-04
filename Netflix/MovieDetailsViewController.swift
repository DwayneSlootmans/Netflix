//
//  MovieDetailsViewController.swift
//  Netflix
//
//  Created by Slootmans Dwayne on 25/11/15.
//  Copyright © 2015 Tiny Rock Productions. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    var movie:Movie?
    @IBOutlet weak var imageViewBackgroundImage: UIImageView!
    
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblCategoryAndRuntime: UILabel!
    @IBOutlet weak var starRating: EDStarRating!
    @IBOutlet weak var lblCast: UILabel!
    @IBOutlet weak var lblDirector: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up star rating control
        starRating.editable = false
        starRating.starImage = UIImage(named: "star")
        starRating.starHighlightedImage = UIImage(named: "starhighlighted")
        starRating.horizontalMargin = 3
        
        setDetails()
        applyBlurEffect()
    }
    
    private func setDetails() {
        if let currentMovie = self.movie {
            self.title = currentMovie.title
            imageViewBackgroundImage.setImageWithURL(NSURL(string:currentMovie.poster), placeholderImage: UIImage(named: "movie_background"))
            lblReleaseDate.text = "Released in \(currentMovie.releaseYear)"
            lblCategoryAndRuntime.text = "\(currentMovie.category) (\(currentMovie.runtime))"
            starRating.rating = Float(currentMovie.rating)
            lblCast.text = "Cast: \(currentMovie.cast)"
            lblDirector.text = "Director: \(currentMovie.director)"
            lblSummary.text = "\(currentMovie.summary)"
        }
    }

    private func applyBlurEffect() {
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            self.view.addSubview(blurEffectView)
            self.view.sendSubviewToBack(blurEffectView)
            self.view.sendSubviewToBack(self.imageViewBackgroundImage)
        }
        else {
            self.view.backgroundColor = UIColor.blackColor()
        }
    }
}