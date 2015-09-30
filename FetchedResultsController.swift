//
//  FetchedResultsController.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/30/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import UIKit
import CoreData

class FetchedResultsController {
    
    class func newParsingPlaylistFRC() -> NSFetchedResultsController {
        let request = NSFetchRequest(entityName: "ParsingPlaylist");
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataHelper.data.context, sectionNameKeyPath: nil, cacheName: nil);
        
        do {
            try frc.performFetch();
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        return frc;
    }
    
    
}
