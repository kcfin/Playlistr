//
//  Track.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/30/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import Foundation
import CoreData

class Track: NSManagedObject {

    class func newTrack(name: String, date: NSDate, uri: String, playlist: Playlist, year: Year) -> Track {
        let entity = NSEntityDescription.entityForName("Track", inManagedObjectContext: CoreDataHelper.data.context);
        let track = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: CoreDataHelper.data.context) as! Track;
        track.name = name;
        track.dateAdded = date;
        track.uri = uri;
        track.playlist = playlist;
        track.year = year;
//        track.artist = artist;
        CoreDataHelper.data.save();
        return track;
    }
    
    class func trackExists(uri: String, playlist: Playlist, year: Year) -> Bool {
        let request = NSFetchRequest(entityName: "Track");
        let yearPred = NSPredicate(format: "year == %@", year)
        let playlistPred = NSPredicate(format: "playlist == %@", playlist)
        let uriPred = NSPredicate(format: "uri == %@", uri)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPred, playlistPred, uriPred])
        
        var error: NSError?;
        let results = CoreDataHelper.data.context.countForFetchRequest(request, error: &error);
        
        if let e = error {
            print("error fetching track \(e)");
            return false;
        }
        
        if (results != 0) {
            return true;
        } else {
            return false;
        }
    }
}
