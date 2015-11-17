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

    class func newTrack(name: String, date: NSDate, uri: String, artist: String) -> Track {
        let entity = NSEntityDescription.entityForName("Track", inManagedObjectContext: CoreDataHelper.data.privateContext);
        let track = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: CoreDataHelper.data.privateContext) as! Track;
        track.name = name;
        track.dateAdded = date;
        track.uri = uri;
        track.artist = artist;
        CoreDataHelper.data.privateSave();
        return track;
    }
    
    class func trackExists(uri: String, playlist: Playlist) -> Track? {
        let request = NSFetchRequest(entityName: "Track");
//        let yearPred = NSPredicate(format: "year == %@", year)
        let playlistPred = NSPredicate(format: "playlist == %@", playlist)
        let uriPred = NSPredicate(format: "uri == %@", uri)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [playlistPred, uriPred])
        
        let results: [AnyObject]?;
        do {
            results = try CoreDataHelper.data.privateContext.executeFetchRequest(request);
        } catch let error as NSError {
            results = nil
            print("Error fetching playlist: \(error)");
        }
        
        let track = results?.first as? Track;
        return track;
    }
}
