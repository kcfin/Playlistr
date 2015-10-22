//
//  ParsingPlaylist+CoreDataProperties.swift
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

extension ParsingPlaylist {

    @NSManaged var snapshotId: String?
    @NSManaged var spotifyId: String?
    @NSManaged var user: User?

}
