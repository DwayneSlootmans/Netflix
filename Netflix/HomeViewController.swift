//
//  HomeViewController.swift
//  Netflix
//
//  Created by Slootmans Dwayne on 25/11/15.
//  Copyright © 2015 Tiny Rock Productions. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var currentUser:User?
    private var movies:NSArray = Array<Movie>()
    private var favorites:NSArray = Array<String>()
    
    private var selectedMovieIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set delegate and datasource of tableview
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //Get current user if none was passed just to be sure
        if currentUser == nil {
            currentUser = User.getCurrentUserDetails()
        }
        self.title = currentUser?.favoriteActor
        
        // Fetch movies and update data
        if let actor = currentUser?.favoriteActor {
            NetflixRestManager.sharedManager.getMoviesByActor(actor, closure: { (movies) -> Void in
                self.movies = movies
                dispatch_async(dispatch_get_main_queue(),{
                    self.tableView.reloadData()
                })
            })
        }
        // Fetch the favorites from the DB
        self.favorites = Favorite.getAllFavoriteMovieTitles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "HomeToMovieDetailSegue" {
            if let movieDetailsViewController = segue.destinationViewController as? MovieDetailsViewController {
                movieDetailsViewController.movie = movies[selectedMovieIndex] as? Movie
            }
        }
    }

}
