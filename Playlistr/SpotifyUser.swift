//
//  SpotifyUser.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/27/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import UIKit

class SpotifyUser {

    var sptUser: SPTUser?;
    var session: SPTSession?;
    var name: String?;
    var profileImage: UIImage?;
    var playlists: [SPTPlaylistList]?;
    
    init(withSession curSession: SPTSession) {
        session = curSession;
        SPTUser.requestCurrentUserWithAccessToken(session?.accessToken, callback: {(error, object) -> Void in
            if(error != nil) {
                print("error: %@", error.localizedDescription);
                return;
            } else {
                self.sptUser = object as? SPTUser;
                self.setupUserInfo();
            }
        });
    }
    
    func setupUserInfo() {
        name = sptUser?.displayName;
        profileImage = UIImage(data: NSData(contentsOfURL: (sptUser?.largestImage.imageURL)!)!);
    }
}
