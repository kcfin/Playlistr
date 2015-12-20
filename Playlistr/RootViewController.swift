//
//  RootViewController.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/27/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    var playerVC: PlayerViewController?;
    
    @IBOutlet weak var progressText: UITextView!
    
    var didStartFetching = false;
    
    @IBOutlet weak var fetchingStatusIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PlayerVC") as? PlayerViewController;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goToHomeScreen", name: "InitializeUser", object: nil);
        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"receiveFetchingSpotifyNotification:", name: "FetchingSpotifyNotification", object: nil)
        didStartFetching = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToHomeScreen() {
        playerVC!.login();
        performSegueWithIdentifier("GoToNavController", sender: nil);
    }
    
     func receiveFetchingSpotifyNotification(notification: NSNotification){
        let dict = notification.userInfo! as NSDictionary
        
        progressText.text = dict.objectForKey("msg") as! String
        progressText.textAlignment = NSTextAlignment.Center
        
        if(!didStartFetching){
            didStartFetching = true;
            fetchingStatusIndicator.startAnimating()
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "GoToNavController") {
            if let slidingVC = segue.destinationViewController as? SlidingViewController {
                let storyboard = UIStoryboard(name: "Main", bundle: nil);
                let topVC = storyboard.instantiateViewControllerWithIdentifier("HomeNavVC") as? UINavigationController;
                slidingVC.topViewController = topVC;
            }
        }
    }
    
    
}
