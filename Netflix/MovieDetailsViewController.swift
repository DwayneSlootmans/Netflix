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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentMovie = movie {
            self.title = movie?.title
            imageViewBackgroundImage.downloadedFrom(link:currentMovie.poster, contentMode: UIViewContentMode.ScaleToFill)
        }
        applyBlurEffect()
    }

    func applyBlurEffect() {
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            self.view.addSubview(blurEffectView)
        }
        else {
            self.view.backgroundColor = UIColor.blackColor()
        }
    }
}