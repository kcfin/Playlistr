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
    
    class func playlistHasChanged(snapshotId: String, spotifyId: String) -> Bool {
        let request = NSFetchRequest(entityName: "ParsingPlaylist");
        request.predicate = NSPredicate(format: "spotifyId == %@", spotifyId);
        let results: [AnyObject]?;
        do {
            results = try CoreDataHelper.data.context.executeFetchRequest(request);
        } catch let error as NSError {
            results = nil
            print("Error fetching year: \(error)");
        }
        
        if let playlist = results?.first as? ParsingPlaylist {
            if(playlist.snapshotId == snapshotId) {
                return false;
            } else {
                return true;
            }
        } else {
            return true;
        }
    }
}
