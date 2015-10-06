//
//  User.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/29/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {
    
    class func currentUser() -> User? {
        let request = NSFetchRequest(entityName: "User");
        let results: [AnyObject]?;
        do {
            results = try CoreDataHelper.data.context.executeFetchRequest(request);
        } catch let error as NSError {
            results = nil
            print("Error fetching user: \(error)");
            return nil;
        }
        let user = results?.first as? User;
        return user;
    }
    
    class func newUser(displayName: String, imgData: NSData?, context: NSManagedObjectContext) -> User {
        let userEntity = NSEntityDescription.entityForName("User", inManagedObjectContext: context);
        let user = NSManagedObject(entity: userEntity!, insertIntoManagedObjectContext: context) as! User;
        user.name = displayName;
        user.image = imgData;
        CoreDataHelper.data.privateSave();
        return user;
    }
    
    func addParsingPlaylist(playlist: ParsingPlaylist) {
        let playlists = User.currentUser()?.mutableSetValueForKey("parsingPlaylist");
        playlists?.addObject(playlist);
//        CoreDataHelper.data.save();
    }
//
//    class func removeCurrentUser() {
//        
//        //TODO: remove user from core data
//    }
    
}
