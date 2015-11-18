//
//  User+CoreDataProperties.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 10/21/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var image: NSData?
    @NSManaged var name: String?
    @NSManaged var uri: String?
    @NSManaged var parsingPlaylist: NSSet?
    @NSManaged var year: NSOrderedSet?

}
