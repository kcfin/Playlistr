//
//  CoreDataHelper.swift
//
//  Created by Greg Azevedo on 6/8/15.
//  Copyright (c) 2015 gazevedo. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
//    
//    var docsDir: NSURL;
//    var model: NSManagedObjectModel;
//    var coordinator: NSPersistentStoreCoordinator;
//    var store: NSPersistentStore?;
//    var context: NSManagedObjectContext
    
//    override init() {
//        docsDir = CoreDataHelper.setupADD();
//        model = CoreDataHelper.setupModel();
//        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model);
//
//        let ad = UIApplication.sharedApplication().delegate as! AppDelegate;
//        let url = ad.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite");
//        store = try! coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
//    }
//    
//    class func setupADD() -> NSURL {
//        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask);
//        return urls[urls.count-1];
//    }
//    
//    class func setupModel() -> NSManagedObjectModel {
//        let modelURL = NSBundle.mainBundle().URLForResource("PlaylistrModel", withExtension: "momd")!;
//        return NSManagedObjectModel(contentsOfURL: modelURL)!;
//    }
    
    
    var fetchController: NSFetchedResultsController?
    var context: NSManagedObjectContext
    var privateContext: NSManagedObjectContext
    private var coordinator: NSPersistentStoreCoordinator
    private var store: NSPersistentStore
    private var model: NSManagedObjectModel?
    
    static let data = CoreDataHelper()
    
    override init() {
        let modelURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("PlaylistrModel", ofType: "momd")!)
        let storeURL = CoreDataHelper.applicationsStoreDir().URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        
        model = NSManagedObjectModel(contentsOfURL: modelURL)
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
        context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType);
        privateContext.parentContext = context;
        store = try! coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
    }
    
    class func applicationsStoreDir() -> NSURL {
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as String
        let storesDir = NSURL.fileURLWithPath(dir).URLByAppendingPathComponent("Stores")
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(storesDir.path!) {
            print("app dir does not exist")
            do {
                try fileManager.createDirectoryAtURL(storesDir, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Failed to create Stores directory \(error)")
            }
        }
        return storesDir
    }
    
    func save() {
        if self.context.hasChanges {
            var error: NSError?
            do {
                try self.context.save()
//                print("parent context saved")
            } catch let error1 as NSError {
                error = error1
                print("context could not save, error: \(error)")
            }
        } else {
            print("no parent changes to save")
        }
    }
    
    func privateSave() {
        if self.privateContext.hasChanges {
            var error: NSError?
            do {
                try self.privateContext.save()
                print("private context saved")
            } catch let error1 as NSError {
                error = error1
                print("context could not save, error: \(error)")
            }
        } else {
            print("no private changes to save")
        }
    }
}
