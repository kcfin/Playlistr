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
    
    func fetchParsingPlaylists(withSession session: SPTSession, withFinalCallback fCallback: SPTPartialObject -> Void) {
        
        SPTPlaylistList.playlistsForUserWithSession(session, callback: {(error, object) -> Void in
            if(error != nil) {
                print("error: \(error.localizedDescription)");
                return;
            }
            if let list = object as? SPTPlaylistList {
                self.fetchAllPlaylists(withSession: session, withList: list, withFinalCallBack: fCallback);
            }
        });
    }
    
    
    
    //    func fetchSnapshotForPlaylist(withSession session: SPTSession, withPartialPlaylists playlistList: [SPTPartialPlaylist], var withNewArray playlistArray: [SPTPlaylistSnapshot], withCallback callback: ([SPTPlaylistSnapshot]) -> Void) {
    //
    //        var index = 0;
    //        for playlist in playlistList {
    //            SPTPlaylistSnapshot.playlistWithURI(playlist.uri, accessToken: session.accessToken, callback: {(error, object) -> Void in
    //                if(error != nil) {
    //                    print("error: \(error.localizedDescription)");
    //                    return;
    //                }
    //                index++;
    //                if let snapshot = object as? SPTPlaylistSnapshot {
    //                    print("got snapshot \(snapshot.name)");
    //                    playlistArray.append(snapshot);
    //                }
    //                if(index == playlistList.count) {
    //                    callback(playlistArray);
    //                }
    //            })
    //        }
    //    }
    
    
    func fetchAllPlaylists(withSession session: SPTSession, withList playlistList: SPTListPage, withFinalCallBack fCallback: SPTPartialObject -> Void) {
        
        var playlists: [SPTPartialPlaylist] = [SPTPartialPlaylist]();
        for item in playlistList.items {
            if let playlist = item as? SPTPartialPlaylist {
                playlists.append(playlist);
            }
        }
        
        fetchSnapshotForPlaylist(withSession: session, withPartialPlaylists: playlists, withFinalCallback: fCallback, withCallback: {() -> Void in
            if (playlistList.hasNextPage) {
                CoreDataHelper.data.context.performBlock({
                    playlistList.requestNextPageWithAccessToken(session.accessToken, callback:  {(error, object) -> Void in
                        print("fetched next page")
                        if(error != nil) {
                            print("error: \(error.localizedDescription)");
                            return;
                        }
                        if let newPage = object as? SPTListPage {
                            self.fetchAllPlaylists(withSession: session, withList: newPage, withFinalCallBack: fCallback);
                        }
                    })
                });
            }
            else {
                NSNotificationCenter.defaultCenter().postNotificationName("InitializeUser", object: self);
//                CoreDataHelper.data.privateSave();
                
            }
        })
    }
    
    func fetchSnapshotForPlaylist(withSession session: SPTSession, var withPartialPlaylists playlistList: [SPTPartialPlaylist], withFinalCallback fCallback: SPTPartialObject -> Void, withCallback callback: () -> Void) {
        if (playlistList.count > 0)  {
            SPTPlaylistSnapshot.playlistWithURI(playlistList.first!.uri, accessToken: session.accessToken, callback: {(error, object) -> Void in
                CoreDataHelper.data.context.performBlock({
                    if(error != nil) {
                        print("error: \(error.localizedDescription)");
                        return;
                    }
                    if let snapshot = object as? SPTPlaylistSnapshot {
                        if(snapshot.trackCount > 0) {
                            print("got snapshot \(snapshot.name)");
                            fCallback(snapshot);
                            self.fetchTracksForPlaylist(withSession: session, withSnapshot: snapshot, withCallback: fCallback);
                        }
                        playlistList.removeFirst();
                        self.fetchSnapshotForPlaylist(withSession: session, withPartialPlaylists: playlistList, withFinalCallback: fCallback, withCallback: callback);
                    }
                })
            })
        } else {
//            print("finished list");
//            NSNotificationCenter.defaultCenter().postNotificationName("InitializeUser", object: self);
            callback();
        }
    }
    
    //    func fetchSnapshotPlaylist(withSession session: SPTSession, withPlaylist playlist: SPTPartialPlaylist, withCallback callback: (SPTPlaylistSnapshot) -> Void) {
    //        CoreDataHelper.data.privateContext.performBlock({
    //        SPTPlaylistSnapshot.playlistWithURI(playlist.uri, accessToken: session.accessToken, callback: {(error, object) -> Void in
    //                print("snapshot call made");
    //                if(error != nil) {
    //                    print("error: \(error.localizedDescription)");
    //                    return;
    //                }
    //                if let snapshot = object as? SPTPlaylistSnapshot {
    //                    print("Snapshot \(snapshot.name)")
    //                    callback(snapshot);
    //                }
    //            })
    //        })
    //
    //    }
    
    func fetchTracksForPlaylist(withSession session: SPTSession, withSnapshot snapshot: SPTPlaylistSnapshot, withCallback callback: (SPTPartialObject) -> Void) {
        
        if let snapPage = snapshot.firstTrackPage {
            fetchAllTracks(withSession: session, withCallback: callback, withSnapshot: snapPage);
        }
    }
    
    func fetchAllTracks(withSession session: SPTSession, withCallback callback: (SPTPartialObject) -> Void, withSnapshot snapshot: SPTListPage) {
        
        for track in snapshot.items {
            if let temp = track as? SPTPlaylistTrack {
                if(temp.isPlayable) {
                    callback(temp);
                }
            }
        }
        
        if (snapshot.hasNextPage) {
            snapshot.requestNextPageWithSession(session, callback: {(error, object) -> Void in
                CoreDataHelper.data.context.performBlock({
                    if(error != nil) {
                        print("error: \(error.localizedDescription)");
                        return;
                    }
                    if let newPage = object as? SPTListPage {
                        self.fetchAllTracks(withSession: session, withCallback: callback, withSnapshot: newPage)
                    }
                })
            })
        }
    }
}