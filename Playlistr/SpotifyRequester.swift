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
                // TODO: check parsing playlists for changes and update
                // user is already stored in core data
                // check users playlists for changes
                // display data
                NSNotificationCenter.defaultCenter().postNotificationName("InitializeUser", object: self);
                return;
            } else {
                User.removeCurrentUser();
            }
        }
        callback(user);
    }
    
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
            if let temp = playlist as? SPTPartialPlaylist {
                playlistArray.append(temp);
            }
        }
        
//        if playlistList.hasNextPage {
//            playlistList.requestNextPageWithSession(session, callback: {(error, object) -> Void in
//                if(error != nil) {
//                    print("error: \(error.localizedDescription)");
//                    return;
//                }
//                if let newPage = object as? SPTListPage {
//                    self.fetchAllPlaylists(withSession: session, withCallback: callback, withList: newPage, withArray: playlistArray);
//                }
//            })
//        } else {
            callback(playlistArray);
//        }
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
    
    func fetchTracksForPlaylist(withSession session: SPTSession, withSnapshot snapshot: SPTPlaylistSnapshot, withCallback callback: (SPTPlaylistTrack) -> Void) {
        
        if let snapPage = snapshot.firstTrackPage {
            fetchAllTracks(withSession: session, withCallback: callback, withSnapshot: snapPage);
        }
    }
    
    func fetchAllTracks(withSession session: SPTSession, withCallback callback: (SPTPlaylistTrack) -> Void, withSnapshot snapshot: SPTListPage) {
        
        for track in snapshot.items {
            if let temp = track as? SPTPlaylistTrack {
                print(temp.name);
                callback(temp);
            }
        }
        CoreDataHelper.data.privateContext.performBlockAndWait({
            if (snapshot.hasNextPage) {
                snapshot.requestNextPageWithSession(session, callback: {(error, object) -> Void in
                    if(error != nil) {
                        print("error: \(error.localizedDescription)");
                        return;
                    }
                    if let newPage = object as? SPTListPage {
                        self.fetchAllTracks(withSession: session, withCallback: callback, withSnapshot: newPage)
                    }
                })
            }
        })
        
    }

}