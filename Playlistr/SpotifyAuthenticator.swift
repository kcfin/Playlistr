//
//  SpotifyAuthenticator.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/20/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

class SpotifyAuthenticator: NSObject {

    let auth: SPTAuth = SPTAuth.defaultInstance();
    
    func setAuthInfo() {
        auth.clientID = Config.kClientId;
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthUserReadEmailScope, SPTAuthUserReadPrivateScope, SPTAuthUserLibraryReadScope];
        auth.redirectURL = NSURL(string: Config.kCallbackURL);
        auth.sessionUserDefaultsKey = Config.sessionKey;
        
    }
    
    func renewToken() -> Bool {
        var canRenew: Bool = false;
        if let auth = SPTAuth.defaultInstance() {
            auth.renewSession(auth.session, callback: { (error, session) -> Void in
                auth.session = session;
                if((error) != nil) {
                    print("*** Error renewing session: \(error)")
                    canRenew = false;
                } else {
                    canRenew = true;
                }
            })
        }
        
        return canRenew;
    }
}
