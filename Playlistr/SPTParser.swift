//
//  SPTParser.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/29/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import Foundation

class SPTParser {
    
    class func parseSPTUser(sptUser: SPTUser)  {
        var imgData: NSData? = nil;
        if let imgURLData = NSData(contentsOfURL: sptUser.largestImage.imageURL) {
            if let image = UIImage(data: imgURLData) {
                imgData = UIImagePNGRepresentation(image);
            }
        }
        User.newUser(sptUser.displayName, imgData: imgData);
    }
    
    class func parseSnapshotPlaylists(snapshotPlaylist: SPTPlaylistSnapshot) {
        let playlist = ParsingPlaylist.newParsingPlaylist(snapshotPlaylist.snapshotId);
        User.currentUser()?.addParsingPlaylist(playlist);
        
//        if let snapshots = snapshotPlaylists {
//            for playlist in snapshots {
//                let parsingPlaylist = ParsingPlaylist.newParsingPlaylist(playlist.snapshotId);
//                User.currentUser()?.addParsingPlaylist(parsingPlaylist);
//            }
//            NSNotificationCenter.defaultCenter().postNotificationName("InitializeUser", object: self);
//        }
    }
}