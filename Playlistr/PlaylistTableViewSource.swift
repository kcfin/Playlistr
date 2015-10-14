//
//  PlaylistTableViewSource.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/20/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import UIKit
import CoreData;

class PlaylistTableViewSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var frc: NSFetchedResultsController = NSFetchedResultsController();
    
    func setFRC(withFRC nsfrc: NSFetchedResultsController) {
        frc = nsfrc;
    }
    
    let playlists = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath);
        cell.textLabel?.text = playlists[indexPath.row];
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
    
}
