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
    var playlist: Playlist?;
    let auth = SpotifyAuthenticator().auth;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        if(player == nil) {
            player = SPTAudioStreamingController(clientId: auth.clientID);
            player?.playbackDelegate = self;
        }
        
    }
    
    func login() {
        player!.loginWithSession(auth.session, callback: {(error) -> Void in
            if(error != nil) {
                print("error");
                return;
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func isNewPlaylist(newPlaylist: Playlist) -> Bool {
        if(playlist != nil) {
            if(playlist == newPlaylist) {
                return false;
            } else {
                trackURIs.removeAll();
                playlist = newPlaylist;
                return true;
            }
        } else {
            playlist = newPlaylist;
            return true;
        }
    }
    
    
    func playMusic(fromIndex index: Int) {
        
        self.player!.playURIs(self.trackURIs, fromIndex: Int32(index), callback: {(error) -> Void in
            if(error != nil) {
                print("error");
                return;
            }
        })
    }
    
    @IBAction func downButtonPressed(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil);
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
