//
//  Album.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 10/22/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import Foundation
import CoreData

class Album: NSManagedObject {

    class func newAlbum(name: String, uri: String) -> Album {
        let entity = NSEntityDescription.entityForName("Album", inManagedObjectContext: CoreDataHelper.data.privateContext);
        let album = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: CoreDataHelper.data.privateContext) as! Album;
        album.uri = uri;
        album.name = name;
        CoreDataHelper.data.privateSave();
        return album;
    }
    
    class func getOrCreateAlbum(name: String, uri: String) -> Album {
        let request = NSFetchRequest(entityName: "Album");
        let namePred = NSPredicate(format: "name == %@", name)
        let uriPred = NSPredicate(format: "uri == %@", uri)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [namePred, uriPred])
        
        let results: [AnyObject]?;
        do {
            results = try CoreDataHelper.data.privateContext.executeFetchRequest(request);
        } catch let error as NSError {
            results = nil
            print("Error fetching year: \(error)");
        }
        
        if let album = results?.first as? Album {
            return album
        } else {
            return Album.newAlbum(name, uri: uri);
        }
    }
}
