//
//  HomeViewController.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/20/15.
//  Copyright (c) 2015 Katelyn Findlay. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var playlistTableView: UITableView!
    var playlistFRC: NSFetchedResultsController?;
    var profileDataSource: PlaylistTableViewSource = PlaylistTableViewSource();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setupImageView();
        setupNameLabel();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: "InitializeUser", object: nil);
    }
    
    override func viewWillAppear(animated: Bool) {
        playlistTableView.dataSource = self;
        playlistTableView.delegate = self;
    }

    func setupImageView() {
        if let data = User.currentUser()?.image {
            profileImageView.image = UIImage(data: data);
        }
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2;
    }
    
    func setupNameLabel() {
        nameLabel.text = User.currentUser()?.name;
    }
    
    func reloadData() {
        setupImageView();
        setupNameLabel();
        playlistFRC = FetchedResultsController.newParsingPlaylistFRC();
        playlistFRC?.delegate = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (playlistFRC?.sections?.count)!;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (playlistFRC?.sections?[section].numberOfObjects)!;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath);
        
        let pp = playlistFRC?.objectAtIndexPath(indexPath) as! ParsingPlaylist;
        cell.textLabel?.text = pp.snapshotId;
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        return;
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.layoutMargins = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if(segue.identifier == "GoToPlaylist") {
////            if let destinationVC = segue.destinationViewController as? PlayListTableViewController {
////                if let playlistIndex = playlistTableView.indexPathForSelectedRow?.row {
//                    // destination.playlist = playlists[playlistIndex];
//                    // set what is needed
//                }
//            }
//        }
//    }
}
