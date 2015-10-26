//
//  PlayerViewController.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 10/22/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController, SPTAudioStreamingPlaybackDelegate {

    var player: SPTAudioStreamingController?;
    var trackURIs: [NSURL] = [NSURL]();
    var index: Int?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playMusic();

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func setTracks(tracks tracks: [NSURL], fromIndex index: Int) {
//        trackURIs?.removeAll();
//        trackURIs = tracks;
//        playMusic(withTracks: trackURIs!, fromIndex: index);
//    }
    
    func playMusic() {
        let auth = SpotifyAuthenticator().auth;
        
        if(player == nil) {
            player = SPTAudioStreamingController(clientId: auth.clientID);
            player?.playbackDelegate = self;
        }
        
        player!.loginWithSession(auth.session, callback: {(error) -> Void in
            if(error != nil) {
                print("error");
                return;
            }
            print("playing URIS");
            self.player!.playURIs(self.trackURIs, fromIndex: 3, callback: {(error) -> Void in
                if(error != nil) {
                    print("error");
                    return;
                }
                
                print("playing song");
            })
        })
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
