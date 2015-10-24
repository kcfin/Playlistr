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
    var music: [Int: [Int]] = [Int: [Int]]();
    
    init(withRequester curRequester: SpotifyRequester, withSession inSession: SPTSession) {
        context = CoreDataHelper.data.context;
        requester = curRequester;
        session = inSession;
    }
    
    func importData() {
        self.importUser();
    }
    
    func importUser() {
        requester.fetchUser(withSession: session, withCallback: {(user) -> Void in
            self.context.performBlock({
                self.importParsingPlaylists();
                var imgData: NSData? = nil;
                if let imgURLData = NSData(contentsOfURL: user.largestImage.imageURL) {
                    if let image = UIImage(data: imgURLData) {
                        imgData = UIImagePNGRepresentation(image);
                    }
                }
                User.newUser(user.displayName, imgData: imgData, uri: String(user.uri));
            })
        })
    }
    
    func importParsingPlaylists() {
        self.context.performBlockAndWait({
            self.requester.fetchParsingPlaylists(withSession: self.session, withFinalCallback: {(object) -> Void in
                self.context.performBlock({
                    if let snapshot = object as? SPTPlaylistSnapshot {
                        let newPlaylist = ParsingPlaylist.newParsingPlaylist(snapshot.snapshotId, spotifyId: String(snapshot.uri));
                        newPlaylist.user = User.currentUser();
                    } else if let track = object as? SPTPlaylistTrack {
                        self.getDates(forTrack: track);
                    }
                })
            })
        })
    }
    
    
    func getDates(forTrack track: SPTPlaylistTrack) {
        self.context.performBlock({
            let (_, month, year) = track.addedAt.dayMonthYear;
            if let date = Month(rawValue: month)?.description() {
                if var years = self.music[year] {
                    if(!years.contains(month)) {
                        // the year exists, the month doesn't
                        let cdYear = Year.getYear(year)!
                        let newPlaylist = Playlist.newPlaylist(date, monthNumber: month, year: cdYear);
                        let newTrack = Track.newTrack(track.name, date: track.addedAt, uri: String(track.uri), artist: (track.artists.first?.name)!);
                        newTrack.playlist = newPlaylist;
                        newTrack.year = cdYear
                        newTrack.album = Album.getOrCreateAlbum(track.album.name, uri: String(track.album.uri))
                        years.append(month);
                        self.music[year] = years;
                    } else {
                        // the year and the month exist
                        let cdYear = Year.getYear(year)!;
                        let newPlaylist = Playlist.getPlaylist(cdYear, name: date);
                        if(!Track.trackExists(String(track.uri), playlist: newPlaylist!, year: cdYear)) {
                            let newTrack = Track.newTrack(track.name, date: track.addedAt, uri: String(track.uri), artist: (track.artists.first?.name)!)
                            newTrack.playlist = newPlaylist;
                            newTrack.year = cdYear;
                            newTrack.album = Album.getOrCreateAlbum(track.album.name, uri: String(track.album.uri))
                        }
                    }
                } else {
                    // the year doesn't exist, create year and month
                    let newYear = Year.newYear(year);
                    let newPlaylist = Playlist.newPlaylist(date, monthNumber: month, year: newYear);
                    let newTrack = Track.newTrack(track.name, date: track.addedAt, uri: String(track.uri), artist: (track.artists.first?.name)!)
                    newTrack.playlist = newPlaylist;
                    newTrack.year = newYear;
                    newTrack.album = Album.getOrCreateAlbum(track.album.name, uri: String(track.album.uri))
                    self.music[year] = [month];
                    
                }
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