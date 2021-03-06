//
//  Year.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/30/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import Foundation
import CoreData

class Year: NSManagedObject {

    class func newYear(inYear: NSInteger) -> Year {
        let entity = NSEntityDescription.entityForName("Year", inManagedObjectContext: CoreDataHelper.data.privateContext);
        let y = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: CoreDataHelper.data.privateContext) as! Year;
        y.year = inYear;
        y.user = User.currentUser()
        CoreDataHelper.data.privateSave();
        return y;
    }
    
    class func getYear(inYear: NSInteger) -> Year? {
        let request = NSFetchRequest(entityName: "Year");
        request.predicate = NSPredicate(format: "year == %d", inYear)
        let results: [AnyObject]?;
        do {
            results = try CoreDataHelper.data.privateContext.executeFetchRequest(request);
        } catch let error as NSError {
            results = nil
            print("Error fetching year: \(error)");
        }
        
        let year = results?.first as? Year
        return year;
    }
}
