//
//  SPTParser.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/29/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import Foundation
import CoreData

class SPTParser {
    
    var context: NSManagedObjectContext
    var requester: SpotifyRequester
    var session: SPTSession
    
    init(withRequester curRequester: SpotifyRequester, withSession inSession: SPTSession) {
        context = CoreDataHelper.data.privateContext;
        requester = curRequester;
        session = inSession;
    }
    
    func importData() {
        self.importUser();
        self.importParsingPlaylists();
    }
    
    func importUser() {
        requester.fetchUser(withSession: session, withCallback: {(user) -> Void in
            self.context.performBlockAndWait({
                
                var imgData: NSData? = nil;
                if let imgURLData = NSData(contentsOfURL: user.largestImage.imageURL) {
                    if let image = UIImage(data: imgURLData) {
                        imgData = UIImagePNGRepresentation(image);
                    }
                }
                User.newUser(user.displayName, imgData: imgData);
            })
        })
    }
    
    func importParsingPlaylists() {
        self.requester.fetchSnapshotPlaylist(withSession: self.session, withCallback: {(snapshot, shouldSave) -> Void in
            self.context.performBlockAndWait({
                let playlist = ParsingPlaylist.newParsingPlaylist(snapshot.name);
                User.currentUser()?.addParsingPlaylist(playlist);
                print(snapshot.name);
                if(shouldSave) {
                    CoreDataHelper.data.privateSave();
                    NSNotificationCenter.defaultCenter().postNotificationName("InitializeUser", object: self);
                }
            })
        })
    }
}