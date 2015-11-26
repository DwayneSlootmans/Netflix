//
//  User+CoreDataProperties.swift
//  Netflix
//
//  Created by Slootmans Dwayne on 26/11/15.
//  Copyright © 2015 Tiny Rock Productions. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var favoriteActor: String?
    @NSManaged var profilePicture: NSData?
    @NSManaged var userName: String?

}
