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
    var tracks : [Track] = [Track]();
    var months : [Int: [Track]] = [Int: [Track]]();
    var music: [Int :[Int : [Track]]] = [Int :[Int : [Track]]]();
    
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
                    self.getDates(forTrack: track);
                    
                }
            })
        })
    }
    
    
    func getDates(forTrack track: SPTPlaylistTrack) {
        self.context.performBlock({
            let (_, month, year) = track.addedAt.dayMonthYear;
            if let date = Month(rawValue: month)?.description() {
                
//                let newYear = Year.newYear(year);
//                let newPlaylist = Playlist.addOrGetPlaylist(newYear, name: date)
                let newTrack = Track.newTrack(track.name, date: track.addedAt);
                if let years = self.music[year] {
                    if let months = years[month] {
                        
                    } else {
//                        music[year][month] = [newTrack];
                    }
                }

//                newPlaylist.mutableArrayValueForKey("Track").addObject(newTrack);
            }
        })

    }
    
    enum Month: Int  {
        case January = 1, February, March, April, May, June, July, August, September, October, November, December;
        
        func description() -> String {
            switch self {
            case January:
                return "January"
            case February:
                return "February"
            case March:
                return "March"
            case April:
                return "April"
            case May:
                return "May"
            case June:
                return "June"
            case July:
                return "July"
            case August:
                return "August"
            case September:
                return "September"
            case October:
                return "October"
            case November:
                return "November"
            case December:
                return "December"
            }
        }
    }
    
}