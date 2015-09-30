//
//  SpotifyUser.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/27/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import UIKit

class SpotifyUser {

    static let user = SpotifyUser();
    var sptUser: SPTUser?;
    var session: SPTSession?;
    var name: String?;
    var profileImage: UIImage?;
    var playlists: SPTPlaylistList?;
    
    func handle(withSession curSession: SPTSession) {
        session = curSession;
        SPTUser.requestCurrentUserWithAccessToken(session?.accessToken, callback: {(error, object) -> Void in
            if(error != nil) {
                print("error: %@", error.localizedDescription);
                return;
            } else {
                self.sptUser = object as? SPTUser;
                self.initializeUserInfo();
            }
        });
    }
    
    func initializeUserInfo() {
        self.name = self.sptUser?.displayName;
        if let url = self.sptUser?.largestImage.imageURL {
            self.profileImage = UIImage(data: NSData(contentsOfURL: url)!);
        }
        NSNotificationCenter.defaultCenter().postNotificationName("InitializeUser", object: self);
    }
    
    func fetchPlaylists() {
        SPTPlaylistList.playlistsForUser(name, withSession: session, callback: {(error, object) -> Void in
            if(error != nil) {
                print("error: %@", error.localizedDescription);
                return;
            } else {
                self.playlists = object as? SPTPlaylistList;
            }
        })
    }
}
