//
//  LoginViewController.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/27/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, SPTAuthViewDelegate {

    let authenticator: SpotifyAuthenticator = SpotifyAuthenticator();
    let authVC: SPTAuthViewController = SPTAuthViewController();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.modalPresentationStyle = UIModalPresentationStyle.CurrentContext;
        self.definesPresentationContext = true;
        setupAuthVC();
    }

    override func viewWillAppear(animated: Bool) {
        if(authenticator.auth.hasTokenRefreshService) {
            if(authenticator.renewToken()) {
                goToMainView();
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupAuthVC() {
        authVC.delegate = self;
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil);
        authVC.navigationItem.backBarButtonItem = backButton;
        authVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext;
        authVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve;
    }
    
    func goToMainView() {
        let appDelegate = UIApplication.sharedApplication().delegate;
        appDelegate?.window??.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController();
    }
    
    // MARK: - IBActions
    @IBAction func loginButtonPressed(sender: AnyObject) {
        presentViewController(authVC, animated: false, completion: nil);
    }
    
    // MARK: - SPTAuthViewDelegate Methods
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        print("*** Failed to log in: %@", error);
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        goToMainView();
    }
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        print("*** Cancelled log in.");
    }

}
