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
    
    func fetchUser(withSession session: SPTSession) -> SPTUser {
        SPTUser.requestCurrentUserWithAccessToken(session.accessToken, callback: {(error, object) -> Void in
            if(error != nil) {
                print("error: %@", error.localizedDescription);
                return;
            } else {
                self.sptUser = object as? SPTUser;
            }
        });
        return sptUser!;
    }
}