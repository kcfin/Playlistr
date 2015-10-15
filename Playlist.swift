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

    class func newPlaylist(name: String, monthNumber: Int, year: Year) -> Playlist {
        let entity = NSEntityDescription.entityForName("Playlist", inManagedObjectContext: CoreDataHelper.data.privateContext);
        let playlist = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: CoreDataHelper.data.privateContext) as! Playlist;
        playlist.name = name;
        playlist.month = monthNumber;
        playlist.year = year;
        CoreDataHelper.data.privateSave();
//        CoreDataHelper.data.save()
        return playlist;
    }
    
    class func getPlaylist(inYear: Year, name: String) -> Playlist? {
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
        
        let playlist = results?.first as? Playlist
        return playlist;
    }
}
