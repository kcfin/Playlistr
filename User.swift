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

    static var cachedUser: User?;
    var session: SPTSession?;
    var profileImage: UIImage?;
    var coreData: CoreDataHelper = CoreDataHelper();

    
    static func user() -> User {
        if(cachedUser == nil) {
            // request from core data and set user
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.managedObjectContext;
            let fetchRequest = NSFetchRequest(entityName: "User");
            
            do {
                let fetchedResults = try context.executeFetchRequest(fetchRequest) as! [User];
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
        convertToImage(withURLString: imageURL);
        coreData.save();
    }
    
    func convertToImage(withURLString urlString: String)
    {
        if let url = NSURL(string: urlString) {
            profileImage = UIImage(data: NSData(contentsOfURL: url)!);
        }
    }
    
}
