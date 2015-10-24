//
//  SpotifyPlayer.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 10/22/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import UIKit

class SpotifyPlayer  {
    
    var player: SPTAudioStreamingController?
    
    init() {
    }
    
    func playTrack(trackUri: [NSURL]) {
        let authenticator = SpotifyAuthenticator();
        player = SPTAudioStreamingController(clientId: authenticator.auth.clientID);
        self.player?.loginWithSession(authenticator.auth.session, callback: {(error) -> Void in
            if(error != nil) {
                print("error: \(error.localizedDescription)");
                return;
            }
            
            self.player?.playURIs(trackUri, fromIndex: 0, callback: {(error) -> Void in
                if(error != nil) {
                    print("error: \(error.localizedDescription)");
                    return;
                }
            })
            
//            self.player?.playURI(trackUri, callback: {(error) -> Void in
//                if(error != nil) {
//                    print("error: \(error.localizedDescription)");
//                    return;
//                }
//            })
        })
        
    }
    
}
