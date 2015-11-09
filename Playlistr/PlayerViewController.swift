//
//  PlayerViewController.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 10/22/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController, SPTAudioStreamingPlaybackDelegate {
    
    @IBOutlet weak var pauseButton: UIImageView!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    var player: SPTAudioStreamingController?;
    var trackURIs: [NSURL] = [NSURL]();
    var trackList: [Track] = [Track]();
    var playlist: Playlist?;
    let auth = SpotifyAuthenticator().auth;
    var index: Int?;
    
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
    
    func setAlbumArtwork() {
        dispatch_async(dispatch_get_main_queue()) {
            self.albumCover.image = nil;
        }
        
        SPTTrack.trackWithURI(trackURIs[index!], session: auth.session, callback: {(error, object) -> Void in
            if(error != nil) {
                print("error fetching track for player view");
                return;
            }
            
            if let track = object as? SPTPartialTrack {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    if let data = NSData(contentsOfURL: track.album.largestCover.imageURL) {
                        if let image = UIImage(data: data) {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.albumCover.image = image;
                            }
                        }
                    }
                }
                
            }
        })
    }
    
    
    func setTrackInfo() {
        dispatch_async(dispatch_get_main_queue()) {
            self.trackLabel.text = self.trackList[self.index!].name;
            self.artistLabel.text = self.trackList[self.index!].artist;
            if let albumText = self.trackList[self.index!].album?.name {
                self.albumLabel.text = albumText;
            }
        }
    }
    
    func isNewPlaylist(newPlaylist: Playlist) -> Bool {
        if(playlist != nil) {
            if(playlist == newPlaylist) {
                return false;
            } else {
                trackURIs.removeAll();
                trackList.removeAll();
                playlist = newPlaylist;
                return true;
            }
        } else {
            playlist = newPlaylist;
            return true;
        }
    }
    
    
    func playMusic() {
        setAlbumArtwork();
        setTrackInfo();
        
        self.player!.playURIs(self.trackURIs, fromIndex: Int32(index!), callback: {(error) -> Void in
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
