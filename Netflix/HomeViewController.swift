//
//  HomeViewController.swift
//  Netflix
//
//  Created by Slootmans Dwayne on 25/11/15.
//  Copyright © 2015 Tiny Rock Productions. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var currentUser:User?
    private var movies:NSArray = Array<Movie>()
    private var favorites:NSArray = Array<String>()
    
    private var selectedMovieIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set delegate and datasource of tableview
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //Get current user if none was passed just to be sure
        if currentUser == nil {
            currentUser = NetflixDataManager.sharedManager.getCurrentUserDetails()
        }
        self.title = currentUser?.favoriteActor
        
        // Fetch movies and update data
        if let actor = currentUser?.favoriteActor {
            NetflixRestManager.sharedManager.getMoviesByActor(actor, closure: { (movies) -> Void in
                self.movies = movies
                dispatch_async(dispatch_get_main_queue(),{
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                })
            })
        }
        // Fetch the favorites from the DB
        self.favorites = NetflixDataManager.sharedManager.getAllFavoriteMovieTitles()
    }
    
    @IBAction func segmentedControlDidChangeValue(sender: AnyObject) {
        if segmentedControl.selectedSegmentIndex == 0 {
            self.collectionView.hidden = true
            self.tableView.hidden = false
            self.tableView.reloadData()
        } else {
            self.collectionView.hidden = false
            self.collectionView.reloadData()
            self.tableView.hidden = true
        }
    }
    
    //MARK - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedMovieIndex = indexPath.row
        performSegueWithIdentifier("HomeToMovieDetailSegue", sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("movieCell") as! MovieTableViewCell
        
        if let movie = movies[indexPath.row] as? Movie {
            if favorites.containsObject(movie.title) {
                cell.btnFavorite.setImage(UIImage(named: "favorite_full"), forState: UIControlState.Normal)
            }
            cell.lblTitle.text = "\(movie.title) (\(movie.releaseYear))"
            cell.movie = movie
        }
        
        return cell
    }

    //MARK: - CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedMovieIndex = indexPath.row
        performSegueWithIdentifier("HomeToMovieDetailSegue", sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("movieCollectionCell", forIndexPath: indexPath) as! MovieTableCollectionViewCell
        
        if let movie = movies[indexPath.row] as? Movie {
            if favorites.containsObject(movie.title) {
                cell.btnFavorite.setImage(UIImage(named: "favorite_full"), forState: UIControlState.Normal)
            }
            if !movie.poster.isEmpty {
                cell.imageViewPoster.downloadedFrom(link: movie.poster, contentMode: UIViewContentMode.ScaleAspectFit)
            }
            cell.lblTitle.text = "\(movie.title) (\(movie.releaseYear))"
            cell.movie = movie
        }
        
        return cell
    }
    
    //MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "HomeToMovieDetailSegue" {
            if let movieDetailsViewController = segue.destinationViewController as? MovieDetailsViewController {
                movieDetailsViewController.movie = movies[selectedMovieIndex] as? Movie
            }
        }
    }

}
