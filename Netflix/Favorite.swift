//
//  Favorite.swift
//  Netflix
//
//  Created by Slootmans Dwayne on 26/11/15.
//  Copyright © 2015 Tiny Rock Productions. All rights reserved.
//

import Foundation
import CoreData


class Favorite: NSManagedObject {
    
    //Fetch all the favorites
    class func getAllFavoriteMovieTitles() -> Array<String> {
        var favorites  = [Favorite]()
        
        let fetchRequest = NSFetchRequest(entityName: "Favorite")
        do {
            favorites = try NetflixCoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest) as! [Favorite]
        } catch let fetchError as NSError {
            print("getGalleryForItem error: \(fetchError.localizedDescription)")
        }
        var result = [String]()
        for favorite:Favorite in favorites {
            if let title = favorite.movieTitle {
                result.append(title)
            }
        }
        return result
    }
    
    //Add a favorite to the DB
    class func addFavorite(movieTitle:String) {
        let favorite = NSEntityDescription.insertNewObjectForEntityForName("Favorite", inManagedObjectContext: NetflixCoreDataStack.sharedInstance.managedObjectContext) as! Favorite
        favorite.movieTitle = movieTitle
        NetflixCoreDataStack.sharedInstance.saveContext()
    }
    
    //Remove a favorite from the DB
    class func removeFromFavorites(movieTitle:String) {
        let fetchRequest = NSFetchRequest(entityName: "Favorite")
        let predicate = NSPredicate(format: "movieTitle = %@", movieTitle)
        fetchRequest.predicate = predicate
        do {
            let favorites = try NetflixCoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest) as! [Favorite]
            for favorite:Favorite in favorites {
                NetflixCoreDataStack.sharedInstance.managedObjectContext.deleteObject(favorite)
                NetflixCoreDataStack.sharedInstance.saveContext()
            }
            
        } catch let fetchError as NSError {
            print("getGalleryForItem error: \(fetchError.localizedDescription)")
        }
    }
}
