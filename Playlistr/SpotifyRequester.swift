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
            } else {
                // need to remove previous user and replace with current user
                User.removeCurrentUser();
            }
        }
        callback(user);
    }
    
//    func fetchParsingPlaylists(withSession session: SPTSession, withCallback callback: ([SPTPlaylistSnapshot]) -> Void) {
//        fetchAllParsingPlaylists(withSession: session, withCallback: callback);
//    }
    
    func fetchParsingPlaylists(withSession session: SPTSession, withCallback callback: ([SPTPartialPlaylist]) -> Void) {
        
        SPTPlaylistList.playlistsForUserWithSession(session, callback: {(error, object) -> Void in
            if(error != nil) {
                print("error: \(error.localizedDescription)");
                return;
            }
            if let list = object as? SPTPlaylistList {
                self.fetchAllPlaylists(withSession: session, withCallback: callback, withList: list, withArray: [SPTPartialPlaylist]());
            }
        });
    }
    
    func fetchAllPlaylists(withSession session: SPTSession, withCallback callback: ([SPTPartialPlaylist]) -> Void, withList playlistList: SPTListPage, var withArray playlistArray: [SPTPartialPlaylist]) {
        
        for playlist in playlistList.items {
            playlistArray.append(playlist as! SPTPartialPlaylist);
        }
        
        if playlistList.hasNextPage {
            playlistList.requestNextPageWithSession(session, callback: {(error, object) -> Void in
                if(error != nil) {
                    print("error: \(error.localizedDescription)");
                    return;
                }
                if let newPage = object as? SPTListPage {
                    self.fetchAllPlaylists(withSession: session, withCallback: callback, withList: newPage, withArray: playlistArray);
                }
            })
        } else {
            callback(playlistArray);
        }
    }
    
    func fetchSnapshotPlaylist(withSession session: SPTSession, withCallback callback: (SPTPlaylistSnapshot, Bool) -> Void) {
        fetchParsingPlaylists(withSession: session, withCallback: { (playlistList) -> Void in
            var index = 0;
            var shouldSave = false;
            for partialPlaylist in playlistList {
                SPTPlaylistSnapshot.playlistWithURI(partialPlaylist.uri, session: session, callback: {(error, object) -> Void in
                    if(error != nil) {
                        print("error: \(error.localizedDescription)");
                        return;
                    }
                    if let snapshot = object as? SPTPlaylistSnapshot {
                        index++;
                        if(index == playlistList.count) {
                            shouldSave = true;
                        }
                        callback(snapshot, shouldSave);
                    }
                    
                })
            }
        });
    }
    
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
//            if(error != nil) {
//                print("error: \(error.localizedDescription)");
//                return;
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