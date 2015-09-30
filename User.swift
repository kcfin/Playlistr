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

    var cachedUser: User?;
    var session: SPTSession?;
    var image: UIImage?;
    var coreData: CoreDataHelper = CoreDataHelper();
    
    func user() -> User {
        if(cachedUser == nil) {
            // request from core data and set user
            let fetchRequest = NSFetchRequest(entityName: "User");
            
            do {
                let fetchedResults = try coreData.context.executeFetchRequest(fetchRequest) as! [User];
                cachedUser = fetchedResults.first;
            } catch let error as NSError {
                print("Could not fetch user: \(error)")
            }
        }
        return cachedUser!;
    }
    
    func initAndSaveUser(withName inName: String, withImageURL imageURL: String) {
        let userEntity = NSEntityDescription.entityForName("User", inManagedObjectContext: coreData.context);
        let user = NSManagedObject(entity: userEntity!, insertIntoManagedObjectContext: coreData.context);
        user.setValue(inName, forKey: "name");
        user.setValue(imageURL, forKey: "imageURL");
        coreData.save();
    }
    
}
