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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PlayerVC") as? PlayerViewController;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goToHomeScreen", name: "InitializeUser", object: nil);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToHomeScreen() {
        playerVC!.login();
        performSegueWithIdentifier("GoToNavController", sender: nil);
    }
}
