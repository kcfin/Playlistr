//
//  ParsingPlaylist.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/30/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import Foundation
import CoreData

class ParsingPlaylist: NSManagedObject {

    class func newParsingPlaylist(snapshotId: String, spotifyId: String) -> ParsingPlaylist {
        let entity = NSEntityDescription.entityForName("ParsingPlaylist", inManagedObjectContext: CoreDataHelper.data.context);
        let parsingPlaylist = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: CoreDataHelper.data.context) as! ParsingPlaylist;
        parsingPlaylist.snapshotId = snapshotId;
        parsingPlaylist.spotifyId = spotifyId;
        parsingPlaylist.user = User.currentUser();
        CoreDataHelper.data.save();
        return parsingPlaylist;
    }
}
