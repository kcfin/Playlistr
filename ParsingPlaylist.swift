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

    class func newParsingPlaylist(id: String) -> ParsingPlaylist {
        let userEntity = NSEntityDescription.entityForName("ParsingPlaylist", inManagedObjectContext: CoreDataHelper.data.privateContext);
        let parsingPlaylist = NSManagedObject(entity: userEntity!, insertIntoManagedObjectContext: CoreDataHelper.data.privateContext) as! ParsingPlaylist;
        parsingPlaylist.snapshotId = id;
        print("new playlist private save")
        CoreDataHelper.data.privateSave();
        return parsingPlaylist;
    }
}
