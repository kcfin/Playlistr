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
            results = try CoreDataHelper.data.privateContext.executeFetchRequest(request);
        } catch let error as NSError {
            results = nil
            print("Error fetching user: \(error)");
            return nil;
        }
        let user = results?.first as? User;
        return user;
    }
    
    class func newUser(displayName: String, imgData: NSData?) -> User {
        let userEntity = NSEntityDescription.entityForName("User", inManagedObjectContext: CoreDataHelper.data.privateContext);
        let user = NSManagedObject(entity: userEntity!, insertIntoManagedObjectContext: CoreDataHelper.data.privateContext) as! User;
        user.name = displayName;
        user.image = imgData;
        print("new user private save")
        CoreDataHelper.data.privateSave();
        return user;
    }
    
    func addParsingPlaylist(playlist: ParsingPlaylist) {
        let playlists = User.currentUser()?.mutableSetValueForKey("parsingPlaylist");
        playlists?.addObject(playlist);
        print("playlist relationship private save")
        CoreDataHelper.data.privateSave();
    }

    class func removeCurrentUser() {
        if let user = User.currentUser() {
            CoreDataHelper.data.privateContext.deleteObject(user);
            print("delete user private save")
            CoreDataHelper.data.privateSave();
        }
    }
}
