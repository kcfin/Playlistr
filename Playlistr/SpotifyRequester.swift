//
//  SpotifyRequest.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/29/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import Foundation

class SpotifyRequester {
    
    var sptUser: SPTUser?;
    
    func fetchUser(withSession session: SPTSession, withCallback callback: (SPTUser, Bool) -> Void) {
        SPTUser.requestCurrentUserWithAccessToken(session.accessToken, callback: {(error, object) -> Void in
            if(error != nil) {
                print("error: \(error.localizedDescription)");
                return;
            } else {
                if let user = object as? SPTUser {
                    self.sptUser = user;
                    self.compareUsersBeforeParse(withUser: user, withCallback: callback);
                }
            }
        });
    }
    
    func compareUsersBeforeParse(withUser user: SPTUser, withCallback callback: (SPTUser, Bool) -> Void) {
        var isUpdating = false;
        if let cachedUser = User.currentUser() {
            if(cachedUser.uri == String(user.uri)) {
                isUpdating = true;
                NSNotificationCenter.defaultCenter().postNotificationName("InitializeUser", object: self);
            } else {
                User.removeCurrentUser();
            }
        }
        callback(user, isUpdating);
    }
    
    func fetchParsingPlaylists(withSession session: SPTSession, isUpdating: Bool, withFinalCallback fCallback: SPTPartialObject -> Void) {
        
        SPTPlaylistList.playlistsForUserWithSession(session, callback: {(error, object) -> Void in
            if(error != nil) {
                print("error: \(error.localizedDescription)");
                return;
            }
            if let list = object as? SPTPlaylistList {
                self.fetchAllPlaylists(withSession: session, withList: list, isUpdating: isUpdating, withFinalCallBack: fCallback);
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
    
    func fetchAllPlaylists(withSession session: SPTSession, withList playlistList: SPTListPage, isUpdating: Bool, withFinalCallBack fCallback: SPTPartialObject -> Void) {
        
        var playlists: [SPTPartialPlaylist] = [SPTPartialPlaylist]();
        for item in playlistList.items {
            if let playlist = item as? SPTPartialPlaylist {
                if(String(playlist.owner.uri) == User.currentUser()!.uri && playlist.trackCount > 0) {
                    playlists.append(playlist);
                }
            }
        }
        
        fetchSnapshotForPlaylist(withSession: session, withPartialPlaylists: playlists, isUpdating: isUpdating, withFinalCallback: fCallback, withCallback: {() -> Void in
            if (playlistList.hasNextPage) {
                playlistList.requestNextPageWithAccessToken(session.accessToken, callback:  {(error, object) -> Void in
                    print("fetched next page")
                    NSNotificationCenter.defaultCenter().postNotificationName("TestNotification", object: self, userInfo: ["msg":"fetched next page"])
                    if(error != nil) {
                        print("error: \(error.localizedDescription)");
                        return;
                    }
                    if let newPage = object as? SPTListPage {
                        self.fetchAllPlaylists(withSession: session, withList: newPage, isUpdating: isUpdating, withFinalCallBack: fCallback);
                    }
                })
            }
            else {
                ParsingPlaylist.removeDeletedPlaylists();
                CoreDataHelper.data.save();
                NSNotificationCenter.defaultCenter().postNotificationName("InitializeUser", object: self);
            }
        })
    }
    
    func fetchSnapshotForPlaylist(withSession session: SPTSession, var withPartialPlaylists playlistList: [SPTPartialPlaylist], isUpdating: Bool, withFinalCallback fCallback: SPTPartialObject -> Void, withCallback callback: () -> Void) {
        if (playlistList.count > 0)  {
            SPTPlaylistSnapshot.playlistWithURI(playlistList.first!.uri, accessToken: session.accessToken, callback: {(error, object) -> Void in
                if(error != nil) {
                    print("error: \(error.localizedDescription)");
                    return;
                }
                if let snapshot = object as? SPTPlaylistSnapshot {
                    NSNotificationCenter.defaultCenter().postNotificationName("TestNotification", object: self, userInfo: ["msg":"got snapshot \(snapshot.name)"])
                    print("got snapshot \(snapshot.name)");
                    if(isUpdating) {
                        if(ParsingPlaylist.playlistHasChanged(snapshot.snapshotId, spotifyId: String(snapshot.uri))) {
                            print("playlist needs updating");
                            fCallback(snapshot);
                            self.fetchAllTracks(withSession: session, withCallback: fCallback, withSnapshot: snapshot.firstTrackPage);
                        }
                    } else {
                        fCallback(snapshot);
                        self.fetchAllTracks(withSession: session, withCallback: fCallback, withSnapshot: snapshot.firstTrackPage);
                    }
                    playlistList.removeFirst();
                    self.fetchSnapshotForPlaylist(withSession: session, withPartialPlaylists: playlistList, isUpdating: isUpdating, withFinalCallback: fCallback, withCallback: callback);
                }
            })
        } else {
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
    
    //    func fetchTracksForPlaylist(withSession session: SPTSession, withSnapshot snapshot: SPTPlaylistSnapshot, withCallback callback: (SPTPartialObject) -> Void) {
    //
    //        if let snapPage = snapshot.firstTrackPage {
    //            fetchAllTracks(withSession: session, withCallback: callback, withSnapshot: snapPage);
    //        }
    //    }
    
    func fetchAllTracks(withSession session: SPTSession, withCallback callback: (SPTPartialObject) -> Void, withSnapshot snapshot: SPTListPage) {
        
        for track in snapshot.items {
            if let temp = track as? SPTPlaylistTrack {
                if(temp.playableUri != nil) {
                    callback(temp);
                }
            }
        }
        
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
    }
}