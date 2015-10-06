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
        importUser();
    }
    
    func importUser() {
        requester.fetchUser(withSession: session, withCallback: {(user) -> Void in
            self.context.performBlock({
                
                var imgData: NSData? = nil;
                if let imgURLData = NSData(contentsOfURL: user.largestImage.imageURL) {
                    if let image = UIImage(data: imgURLData) {
                        imgData = UIImagePNGRepresentation(image);
                    }
                }
                User.newUser(user.displayName, imgData: imgData, context: self.context);
                CoreDataHelper.data.privateSave();
                CoreDataHelper.data.save();
                NSNotificationCenter.defaultCenter().postNotificationName("InitializeUser", object: self);
            })
        })
    }
    
//    class func parseSPTUser(sptUser: SPTUser)  {
//        var imgData: NSData? = nil;
//        if let imgURLData = NSData(contentsOfURL: sptUser.largestImage.imageURL) {
//            if let image = UIImage(data: imgURLData) {
//                imgData = UIImagePNGRepresentation(image);
//            }
//        }
//        User.newUser(sptUser.displayName, imgData: imgData);
//    }
//    
//    class func parseSnapshotPlaylists(snapshotPlaylist: SPTPlaylistSnapshot) {
//        let playlist = ParsingPlaylist.newParsingPlaylist(snapshotPlaylist.snapshotId);
//        User.currentUser()?.addParsingPlaylist(playlist);
//        
////        if let snapshots = snapshotPlaylists {
////            for playlist in snapshots {
////                let parsingPlaylist = ParsingPlaylist.newParsingPlaylist(playlist.snapshotId);
////                User.currentUser()?.addParsingPlaylist(parsingPlaylist);
////            }
////            NSNotificationCenter.defaultCenter().postNotificationName("InitializeUser", object: self);
////        }
//    }
}