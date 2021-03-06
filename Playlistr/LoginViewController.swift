//
//  LoginViewController.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/27/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, SPTAuthViewDelegate {

    @IBOutlet weak var loginButton: UIButton!
    let authenticator: SpotifyAuthenticator = SpotifyAuthenticator();
    
    override func viewDidLoad() {
        super.viewDidLoad();
//        loginButton.layer.cornerRadius = loginButton.frame.size.height/2;
    }

    override func viewWillAppear(animated: Bool) {
//        if(authenticator.auth.hasTokenRefreshService) {
//            if(authenticator.renewToken()) {
//                goToHomeScreen();
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBActions
@IBAction func loginButtonPressed(sender: AnyObject) {
        let authVC = SPTAuthViewController.authenticationViewController();
        authVC.delegate = self;
        authVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext;
        authVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve;
        self.modalPresentationStyle = UIModalPresentationStyle.CurrentContext;
        self.definesPresentationContext = true;
        presentViewController(authVC, animated: false, completion: nil);
    }
    
    // MARK: - SPTAuthViewDelegate Methods
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        print("*Failed to log in: \(error)");
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil);
        let parser = SPTParser(withRequester: SpotifyRequester(), withSession: session);
        parser.importData();
    }
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        print("Cancelled log in");
    }
}
