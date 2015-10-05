//
//  SpotifyRequest.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/29/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import Foundation

class SpotifyRequester {
    
    func fetchUser(withSession session: SPTSession, withCallback callback: (SPTUser) -> Void) {
        SPTUser.requestCurrentUserWithAccessToken(session.accessToken, callback: {(error, object) -> Void in
            if(error != nil) {
                print("error: \(error.localizedDescription)");
                return;
            } else {
                if let user = object as? SPTUser {
                    self.compareUsersBeforeParse(withUser: user, withCallback: callback);
                }
            }
        });
    }
    
    func compareUsersBeforeParse(withUser user: SPTUser, withCallback callback: (SPTUser) -> Void) {
        if let cachedUser = User.currentUser() {
            if(cachedUser.name == user.displayName) {
                // user is already stored in core data
                // check users playlists for changes
                // display data
                NSNotificationCenter.defaultCenter().postNotificationName("InitializeUser", object: self);
                return;
            }
        }
        callback(user);
    }
    
//    class func fetchUser(withSession session: SPTSession) {
//        SPTUser.requestCurrentUserWithAccessToken(session.accessToken, callback: {(error, object) -> Void in
//            if(error != nil) {
//                print("error: \(error.localizedDescription)");
//                return;
//            } else {
//                if let user = object as? SPTUser {
//                    compareUsersBeforeParse(user);
//                }
//            }
//        });
//    }
//
//    class func compareUsersBeforeParse(sptUser: SPTUser) {
//        if let cachedUser = User.currentUser() {
//            if(cachedUser.name == sptUser.displayName) {
//                NSNotificationCenter.defaultCenter().postNotificationName("InitializeUser", object: self);
//                return;
//            } else {
//                // delete current user
//                
//            }
//        }
//        fetchParsingPlaylists();
//        SPTParser.parseSPTUser(sptUser);
//    }

    
//
//    class func fetchParsingPlaylists() {
//        let session: SPTSession = SpotifyAuthenticator().auth.session;
//        var partialPlaylists: SPTPlaylistList?;
//        
//        SPTPlaylistList.playlistsForUserWithSession(session, callback: {(error, object) -> Void in
//            if(error != nil) {
//                print("error: \(error.localizedDescription)");
//                return;
//            }
//            partialPlaylists = object as? SPTPlaylistList;
//            SpotifyRequester.requestSnapshotFromPartialPlaylist(partialPlaylists!);
//        });
//    }
//    
//    class func requestSnapshotFromPartialPlaylist(partialPlaylistList: SPTPlaylistList) {
//        // maybe change to array of uri and request all at once?
//        let session: SPTSession = SpotifyAuthenticator().auth.session;
//        var playlistURIs: [NSURL]? = nil;
//        var playlistSnapshots: [SPTPlaylistSnapshot]? = nil;
//        
////        for playlist in partialPlaylistList.items {
////            playlistURIs?.append(playlist.URIRepresentation());
////        }
////        
////        SPTPlaylistSnapshot.playlistsWithURIs(playlistURIs, session: session, callback: {(error, object) -> Void in
////            if(error != nil) {
////                print("error: \(error.localizedDescription)");
////                return;
////            }
////            let playlistSnapshots = object as! [SPTPlaylistSnapshot];
////            SPTParser.parseSnapshotPlaylists(playlistSnapshots);
////        });
//        
//        for partialPlaylist in partialPlaylistList.items {
//            SPTPlaylistSnapshot.playlistWithURI(partialPlaylist.uri, session: session, callback: {(error, object) -> Void in
//                if(error != nil) {
//                    print("error: \(error.localizedDescription)");
//                    return;
//                }
//                let playlistSnapshot = object as! SPTPlaylistSnapshot;
////                playlistSnapshots?.append(playlistSnapshot);
//                SPTParser.parseSnapshotPlaylists(playlistSnapshot);
//            });
//        }
//    }
}