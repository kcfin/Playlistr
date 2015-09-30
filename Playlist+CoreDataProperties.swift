//
//  Playlist+CoreDataProperties.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/29/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Playlist {

    @NSManaged var name: String?
    @NSManaged var imageURL: String?
    @NSManaged var user: NSManagedObject?
    @NSManaged var year: NSManagedObject?
    @NSManaged var track: NSSet?

}
