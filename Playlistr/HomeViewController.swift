//
//  HomeViewController.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/20/15.
//  Copyright (c) 2015 Katelyn Findlay. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var playlistTableView: UITableView!
    var profileDataSource: PlaylistTableViewSource?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        profileDataSource = PlaylistTableViewSource();
        playlistTableView.dataSource = profileDataSource;
        playlistTableView.delegate = profileDataSource;
        setupImageView();
    }

    func setupImageView() {
        profileImageView.layer.borderWidth = 3.0;
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor;
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2;
    }
    
    func setupNameLabel() {
        nameLabel.font = UIFont.systemFontOfSize(30);
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
