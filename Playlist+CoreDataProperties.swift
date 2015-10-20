//
//  Playlist+CoreDataProperties.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 10/20/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Playlist {

    @NSManaged var imageURL: String?
    @NSManaged var month: NSNumber?
    @NSManaged var name: String?
    @NSManaged var yearSection: NSNumber?
    @NSManaged var track: NSSet?
    @NSManaged var year: Year?

}
