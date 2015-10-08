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
    var parsingPlaylists: [SPTPartialPlaylist] = [SPTPartialPlaylist]();
    
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
//            self.context.performBlock({
                var imgData: NSData? = nil;
                if let imgURLData = NSData(contentsOfURL: user.largestImage.imageURL) {
                    if let image = UIImage(data: imgURLData) {
                        imgData = UIImagePNGRepresentation(image);
                    }
                }
                User.newUser(user.displayName, imgData: imgData);
            })
//        })
    }
    
    func importParsingPlaylists() {
//        var tracks = [Track]();
        self.requester.fetchParsingPlaylists(withSession: self.session, withCallback: {(playlists, shouldSave) -> Void in
//            self.context.performBlock({
//                print(snapshot.name);
//                let playlist = ParsingPlaylist.newParsingPlaylist(snapshot.name);
//                playlist.user = User.currentUser();
            self.parsingPlaylists = playlists;
//                User.currentUser()?.addParsingPlaylist(playlist);
//                self.context.performBlockAndWait({
//                    self.requester.fetchTracksForPlaylist(withSession: self.session, withSnapshot: snapshot, withCallback: {(track) -> Void in
//                        self.context.performBlockAndWait{
//                            let newTrack = Track.newTrack(track.name, date: track.addedAt);
//                            tracks.append(newTrack);
////                            self.getDates(forTrack: newTrack);
//                        }
//                    });
//                })
                
                if(shouldSave) {
                    self.createNewPlaylists();
                }
//            })
        })
    }
//    
    func createNewPlaylists() {
//        self.context.performBlockAndWait({
            for playlist in self.parsingPlaylists {
                    print(playlist.name);
                    let newPlaylist = ParsingPlaylist.newParsingPlaylist(playlist.name);
                    newPlaylist.user = User.currentUser();
                }
            
            CoreDataHelper.data.privateSave();
            NSNotificationCenter.defaultCenter().postNotificationName("InitializeUser", object: self);
//        })
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