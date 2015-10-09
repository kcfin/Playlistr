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
    var snapshotPlaylists: [SPTPlaylistSnapshot] = [SPTPlaylistSnapshot]();
    
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
        self.requester.fetchParsingPlaylists(withSession: self.session, withFinalCallback: {(object) -> Void in
            self.context.performBlock({
                if let snapshot = object as? SPTPlaylistSnapshot {
                    let newPlaylist = ParsingPlaylist.newParsingPlaylist(snapshot.name);
                    newPlaylist.user = User.currentUser();
                } else if let track = object as? SPTPlaylistTrack {
                    let newTrack = Track.newTrack(track.name, date: track.addedAt);
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