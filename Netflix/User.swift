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

    // Side note here: because there is only 1 user at a time and there are only 3 fields in the user details, I would advise to use NSUSerdefaults here. It is a lot easier, faster and also persisted.
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
        
        // Then you can use your propertys.
        for user in users {
            print(user.userName)
            
        }
        return User()
    }
}
