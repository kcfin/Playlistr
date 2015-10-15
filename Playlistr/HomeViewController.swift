//
//  HomeViewController.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/20/15.
//  Copyright (c) 2015 Katelyn Findlay. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var playlistTableView: UITableView!
    var profileDataSource: PlaylistTableViewSource = PlaylistTableViewSource();
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setupImageView();
        setupNameLabel();
        fetchedResultsController = getFetchedResultsController();
        fetchedResultsController.delegate = self;
        do {
            try fetchedResultsController.performFetch();
        } catch let error as NSError {
            print("error fetching results: \(error)")
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: "InitializeUser", object: nil);
    }
    
    override func viewWillAppear(animated: Bool) {
        reloadData();
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Fetched Results Controller Methods
    func getFetchedResultsController() -> NSFetchedResultsController {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: playlistFetchRequest(), managedObjectContext: CoreDataHelper.data.context, sectionNameKeyPath: "Year.year", cacheName: nil);
        return fetchedResultsController;
    }
    
    func playlistFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Playlist");
        let sortDescriptor = NSSortDescriptor(key: "Year.year", ascending: true);
        let monthSortDescriptor = NSSortDescriptor(key: "month", ascending: true);
        fetchRequest.sortDescriptors = [sortDescriptor, monthSortDescriptor];
        fetchRequest.fetchBatchSize = 20;
        return fetchRequest;
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        playlistTableView.reloadData();
    }

    // MARK: - Table View Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections?.count {
            return sections;
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            return sections[section].name;
        }
        return "";
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects;
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath);
        let playlist = fetchedResultsController.objectAtIndexPath(indexPath) as! Playlist;
        cell.textLabel?.text = playlist.name;
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "GoToPlaylist") {
            if let destinationVC = segue.destinationViewController as? PlayListTableViewController {
                let playlist = fetchedResultsController.objectAtIndexPath(playlistTableView.indexPathForSelectedRow!) as! Playlist;
                let fetchRequest = NSFetchRequest(entityName: "Track");
                let namePred = NSPredicate(format: "playlist == %@", playlist.name!);
                let sortDescriptor = NSSortDescriptor(key: "name", ascending: true);
                fetchRequest.predicate = namePred;
                fetchRequest.sortDescriptors = [sortDescriptor];
                fetchRequest.fetchBatchSize = 20;
                destinationVC.trackFR = fetchRequest;
            }
        }
    }
    
}
