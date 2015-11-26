//
//  User.swift
//  Netflix
//
//  Created by Slootmans Dwayne on 25/11/15.
//  Copyright © 2015 Tiny Rock Productions. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject {

    //Fetch the only record in the DB which represents the current user of the app.
    class func getCurrentUserDetails() -> User {
        var users  = [User]()
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        do {
            users = try NetflixCoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest) as! [User]
            if users.count > 0 {
                return users[0]
            } else {
                return NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: NetflixCoreDataStack.sharedInstance.managedObjectContext) as! User
            }
        } catch let fetchError as NSError {
            print("getGalleryForItem error: \(fetchError.localizedDescription)")
        }
        return User()
    }
}
