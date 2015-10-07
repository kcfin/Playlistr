//
//  Playlist.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/29/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import Foundation
import CoreData

class Playlist: NSManagedObject {

    class func newPlaylist(name: String, year: Year) -> Playlist {
        let entity = NSEntityDescription.entityForName("Playlist", inManagedObjectContext: CoreDataHelper.data.privateContext);
        let playlist = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: CoreDataHelper.data.privateContext) as! Playlist;
        playlist.name = name;
        playlist.year = year;
        return playlist;
    }
    
    class func addOrGetPlaylist(inYear: Year, name: String) -> Playlist {
        let request = NSFetchRequest(entityName: "Playlist");
        let yearPred = NSPredicate(format: "year == %@", inYear);
        let namePred = NSPredicate(format: "name == %@", name);
        var preds : [NSPredicate] = [NSPredicate]();
        preds.append(yearPred);
        preds.append(namePred);
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: preds);
        let results: [AnyObject]?;
        do {
            results = try CoreDataHelper.data.privateContext.executeFetchRequest(request);
        } catch let error as NSError {
            results = nil
            print("Error fetching playlist: \(error)");
        }
        
        if let playlist = results?.first as? Playlist {
            return playlist;
        } else {
            return newPlaylist(name, year: inYear);
        }
    }
}
