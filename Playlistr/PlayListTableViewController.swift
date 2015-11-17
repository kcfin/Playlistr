//
//  PlayListTableViewController.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/28/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import UIKit
import CoreData

class PlaylistTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var playlistLabel: UILabel!
    @IBOutlet weak var albumOne: UIImageView!
    @IBOutlet weak var albumTwo: UIImageView!
    @IBOutlet weak var albumThree: UIImageView!
    @IBOutlet weak var albumFour: UIImageView!
    @IBOutlet var headerView: UIView! {
        didSet {
            headerView.backgroundColor = UIColor.ThemeColor()
        }
    }
    @IBOutlet var trackTableView: UITableView!
    var frc: NSFetchedResultsController = NSFetchedResultsController();
    var trackFR: NSFetchRequest?;
    var playlist: Playlist?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackTableView.delegate = self;
        trackTableView.dataSource = self;
        frc = getFetchedResultsController();
        frc.delegate = self;
        do {
            try frc.performFetch();
        } catch let error as NSError {
            print("error fetching results: \(error)")
        }
        setPlaylistLabel();
        setAlbumImages();
    }
    
    func setAlbumImages() {
        var trackURI: [NSURL] = [NSURL]();
        var albums: [UIImageView] = [albumOne, albumTwo, albumThree, albumFour];
        for _ in 0...3 {
            if let t = frc.objectAtIndexPath(NSIndexPath(forRow: Int(arc4random_uniform(UInt32((frc.fetchedObjects?.count)!-1))), inSection: 0)) as? Track {
                trackURI.append(NSURL(string: t.uri!)!);
            }
        }
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        // do some task
        SPTTrack.tracksWithURIs(trackURI, session: SpotifyAuthenticator().auth.session, callback: {(error, object) -> Void in
            if(error != nil) {
                print("error fetching tracks");
                return;
            }
                // update some UI
                if let tracks = object as? [SPTPartialTrack] {
                    var trackNums: Int;
                    if (tracks.count < albums.count) {
                        trackNums = tracks.count-1;
                    } else {
                        trackNums = albums.count-1;
                    }
                    for index in 0...trackNums {
                        dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        if let data = NSData(contentsOfURL: tracks[index].album.largestCover.imageURL) {
                            if let image = UIImage(data: data) {
                                dispatch_async(dispatch_get_main_queue()) {
                                    albums[index].image = image;
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    func setPlaylistLabel() {
        playlistLabel.text = playlist?.name;
        title = playlist?.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: trackFR!, managedObjectContext: CoreDataHelper.data.context, sectionNameKeyPath: nil, cacheName: nil);
        return fetchedResultsController;
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = frc.sections {
            return sections[section].numberOfObjects;
        }
        return 0;
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("playlistCell", forIndexPath: indexPath)
        let track = frc.objectAtIndexPath(indexPath) as! Track;
        cell.textLabel?.text = track.name;
        var albumName: String = "";
        if let album = track.album {
            if (!album.name!.isEmpty) {
                albumName = " - \(album.name!)";
            }
        }
        cell.detailTextLabel?.text = "\(track.artist!)\(albumName)";
        return cell;
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        trackTableView.reloadData();
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.layoutMargins = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate;
        let rootView = appDelegate.window!.rootViewController as! RootViewController;
        
        if let player = rootView.playerVC {
            if(player.isNewPlaylist(playlist!)) {
                var trackURIs: [NSURL] = [NSURL]();
                var trackList: [Track] = [Track]();
                for object in frc.fetchedObjects! {
                    if let track = object as? Track {
                        trackURIs.append(NSURL(string: track.uri!)!);
                        trackList.append(track);
                    }
                }
                player.trackURIs = trackURIs;
                player.trackList = trackList;
                
            }
            player.index = indexPath.row;
            player.playMusic();
            player.modalPresentationStyle = UIModalPresentationStyle.FullScreen;
            player.modalTransitionStyle = UIModalTransitionStyle.CoverVertical;
            presentViewController(player, animated: true, completion: nil);
        }
    }
}