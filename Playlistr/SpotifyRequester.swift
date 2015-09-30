//
//  SpotifyRequest.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/29/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import Foundation

class SpotifyRequester {
    
    class func fetchUser(withSession session: SPTSession) {
        SPTUser.requestCurrentUserWithAccessToken(session.accessToken, callback: {(error, object) -> Void in
            if(error != nil) {
                print("error: \(error.localizedDescription)");
                return;
            } else {
                if let user = object as? SPTUser {
                    compareUsersBeforeParse(user);
                }
            }
        });
    }
    
    class func compareUsersBeforeParse(sptUser: SPTUser) {
        if let cachedUser = User.currentUser() {
            if(cachedUser.name == sptUser.displayName) {
                NSNotificationCenter.defaultCenter().postNotificationName("InitializeUser", object: self);
                return;
            }
        }
        fetchParsingPlaylists();
        SPTParser.parseSPTUser(sptUser);
    }
    
    class func fetchParsingPlaylists() {
        let session: SPTSession = SpotifyAuthenticator().auth.session;
        var partialPlaylists: SPTPlaylistList?;
        
        SPTPlaylistList.playlistsForUserWithSession(session, callback: {(error, object) -> Void in
            if(error != nil) {
                print("error: \(error.localizedDescription)");
                return;
            }
            partialPlaylists = object as? SPTPlaylistList;
            SpotifyRequester.requestSnapshotFromPartialPlaylist(partialPlaylists!);
        });
    }
    
    class func requestSnapshotFromPartialPlaylist(partialPlaylistList: SPTPlaylistList) {
        // maybe change to array of uri and request all at once?
        let session: SPTSession = SpotifyAuthenticator().auth.session;
        var playlistURIs: [NSURL]? = nil;
        var playlistSnapshots: [SPTPlaylistSnapshot]? = nil;
        
//        for playlist in partialPlaylistList.items {
//            playlistURIs?.append(playlist.URIRepresentation());
//        }
//        
//        SPTPlaylistSnapshot.playlistsWithURIs(playlistURIs, session: session, callback: {(error, object) -> Void in
//            if(error != nil) {
//                print("error: \(error.localizedDescription)");
//                return;
//            }
//            let playlistSnapshots = object as! [SPTPlaylistSnapshot];
//            SPTParser.parseSnapshotPlaylists(playlistSnapshots);
//        });
        
        for partialPlaylist in partialPlaylistList.items {
            SPTPlaylistSnapshot.playlistWithURI(partialPlaylist.uri, session: session, callback: {(error, object) -> Void in
                if(error != nil) {
                    print("error: \(error.localizedDescription)");
                    return;
                }
                let playlistSnapshot = object as! SPTPlaylistSnapshot;
//                playlistSnapshots?.append(playlistSnapshot);
                SPTParser.parseSnapshotPlaylists(playlistSnapshot);
            });
        }
    }
}