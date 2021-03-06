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
//        CoreDataHelper.data.privateContext.performBlock({
//        
//        })
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
    
    class func newUser(displayName: String, imgData: NSData?, uri: String) -> User {
        let userEntity = NSEntityDescription.entityForName("User", inManagedObjectContext: CoreDataHelper.data.privateContext);
        let user = NSManagedObject(entity: userEntity!, insertIntoManagedObjectContext: CoreDataHelper.data.privateContext) as! User;
        user.name = displayName;
        user.image = imgData;
        user.uri = uri;
        CoreDataHelper.data.privateSave();
        CoreDataHelper.data.save();
        return user;
    }

    class func removeCurrentUser() {
        if let user = User.currentUser() {
            CoreDataHelper.data.context.deleteObject(user);
            print("delete user save")
            CoreDataHelper.data.save();
        }
    }
}
