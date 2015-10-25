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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let adele: NSURL = NSURL(string: "spotify:track:0ENSn4fwAbCGeFGVUbXEU3")!;
        let magnets: NSURL = NSURL(string: "spotify:track:7nRmfGNhHKEEu5o8yFXLXt")!;
        var songs: [NSURL] = [NSURL]();
        songs.append(adele);
        songs.append(magnets);
        player = SPTAudioStreamingController(clientId: SPTAuth.defaultInstance().clientID)!;
        player?.playbackDelegate = self;
//        player!.diskCache = SPTDiskCache(capacity: 1024 * 1024 * 64)
        player!.loginWithSession(SPTAuth.defaultInstance().session, callback: {(error) -> Void in
            if(error != nil) {
                print("error");
                return;
            }
            print("playing URIS");
            self.player!.playURIs(songs, fromIndex: 0, callback: {(error) -> Void in
                if(error != nil) {
                    print("error");
                    return;
                }
                
                print("playing music");
            })
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
