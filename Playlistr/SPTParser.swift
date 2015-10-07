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
            self.context.performBlock({
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
                self.context.performBlockAndWait({
                    self.requester.fetchTracksForPlaylist(withSession: self.session, withSnapshot: snapshot, withCallback: {(track) -> Void in
                        self.context.performBlockAndWait{
                            let newTrack = Track.newTrack(track.name, date: track.addedAt);
                            self.getDates(forTrack: newTrack);
                        }
                    });
                })
                
                if(shouldSave) {
                    
                    CoreDataHelper.data.privateSave();
                    NSNotificationCenter.defaultCenter().postNotificationName("InitializeUser", object: self);
                }
            })
        })
    }
    
    func getDates(forTrack track: Track) {
        if let date: NSDate = track.dateAdded {
            let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: date)
            let year = Year.addOrGetYear(components.year);
            let playlist = Playlist.addOrGetPlaylist(year, name: "\(Month(rawValue: components.month))");
            print(year.year);
            print(playlist.name);
        }
//        let month = components.month
//        let year = components.year
        

    }
    
    enum Month: Int  {
        case January = 1, February, March, April, May, June, July, August, September, October, November, December;
    }
    
}