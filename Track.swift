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

    class func newTrack(name: String, date: NSDate) -> Track {
        let entity = NSEntityDescription.entityForName("Track", inManagedObjectContext: CoreDataHelper.data.context);
        let track = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: CoreDataHelper.data.context) as! Track;
        track.name = name;
        track.dateAdded = date;
//        track.artist = artist;
        CoreDataHelper.data.save();
        return track;
    }
}
