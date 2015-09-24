//
//  SpotifyAuthenticator.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/20/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

class SpotifyAuthenticator: NSObject {

    let kClientId = "3d912a8a1aa64b11b07abeecc30df390"
    let kCallbackURL = "playlistr-login://callback"
    let kTokenSwapURL = "http://localhost:1234/swap"
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func getLoginURL() -> NSURL {
        return SPTAuth.loginURLForClientId(kClientId, withRedirectURL: NSURL(string: kCallbackURL), scopes: [SPTAuthStreamingScope], responseType: "token");
    }
    
    func canAuthenticateUser(callbackURL url: NSURL) -> Bool {
        
        var canAuthenticate: Bool = false;
        if(SPTAuth.defaultInstance().canHandleURL(NSURL(string: kCallbackURL))) {
            SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(NSURL(string: kCallbackURL), callback: { (error, session) -> Void in
                if(error != nil) {
                    print("*** Auth error: \(error)")
                    return;
                }
                canAuthenticate = true;
            });
        }
        return canAuthenticate;
    }
    
}
