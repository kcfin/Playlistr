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
        parsingPlaylist.dateChecked = NSDate().dateWithoutTime();
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
                // playlist does not need updating
                playlist.dateChecked = NSDate().dateWithoutTime();
                return false;
            } else {
                // playlist does need updating
                ParsingPlaylist.deletePlaylist(playlist);
                return true;
            }
        } else {
            // playlist is new
            return true;
        }
    }
    
    class func deletePlaylist(playlist: ParsingPlaylist) {
        print("delete playlist \(playlist.spotifyId)")
        CoreDataHelper.data.context.deleteObject(playlist);
        CoreDataHelper.data.save();
    }
    
    class func removeDeletedPlaylists() {
        
    }
}
