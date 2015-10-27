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
    
    @IBOutlet var trackTableView: UITableView!
    var frc: NSFetchedResultsController = NSFetchedResultsController();
    var trackFR: NSFetchRequest?;
    
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
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        if let album = track.album as? Album {
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "GoToPlayer") {
            if let destinationVC = segue.destinationViewController as? PlayerViewController {
                if let index = trackTableView.indexPathForSelectedRow {
                    var trackURIs: [NSURL] = [NSURL]();
                    for object in frc.fetchedObjects! {
                        if let track = object as? Track {
                            trackURIs.append(NSURL(string: track.uri!)!);
                        }
                    }
                    var player = SPTAudioStreamingController(clientId: SpotifyAuthenticator().auth.clientID);
                    destinationVC.player = player;
                    destinationVC.trackURIs = trackURIs;
                    destinationVC.index = index.row;
                }
            }
        }
    }
    
}
