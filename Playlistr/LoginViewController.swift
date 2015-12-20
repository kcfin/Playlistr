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
        print("hello");
        super.viewDidLoad();
//        loginButton.layer.cornerRadius = loginButton.frame.size.height/2;
         
        let FBloginButton = FBSDKLoginButton.init();

        FBloginButton.frame = CGRectMake(0, 0, 200, 50)
        FBloginButton.frame.offsetInPlace(dx: self.view.frame.size.width/4, dy: self.view.frame.size.height/(7/4))
        
        
        self.view.addSubview(FBloginButton);
        
        
        
    }

    override func viewWillAppear(animated: Bool) {
//        if(authenticator.auth.hasTokenRefreshService) {
//            if(authenticator.renewToken()) {
//                goToHomeScreen();
//            }
//        }
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            let profileRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, first_name, last_name, picture"])
            profileRequest.startWithCompletionHandler({
                (connection, result, error: NSError!) -> Void in
                if(error == nil){
                    let dict = result as! NSDictionary
                    
                    print(dict.objectForKey("picture")!.objectForKey("data")!.objectForKey("url"))
                    print(dict.objectForKey("name") as! String)
                    
                    let urlString = dict.objectForKey("picture")!.objectForKey("data")!.objectForKey("url") as! String
                    let url:NSURL? = NSURL(string: urlString);
                    let data: NSData? = NSData(contentsOfURL : url!)
                    let image = UIImage(data: data!)
                    
                    let imageView = UIImageView.init(image: image)
                    imageView.frame = CGRectMake(0, 0, 30, 30)
                    imageView.frame.offsetInPlace(dx: self.view.frame.size.width/2, dy: self.view.frame.size.height*(3/4))
//                    let imageView2 = self.useMaskFor(imageView)
                    
                    self.view.addSubview(imageView)
                    print("HI")
                }else{
                    print("no result")
                }
                
            })
        }
        else{
            print("no profile")
        }
        
        
    }
    
    func useMaskFor(colorArea: UIView) -> UIView{
        let maskLayer = CALayer()
        maskLayer.frame = colorArea.bounds
        let maskImage = UIImage(named: "circle-mask.png")
        maskLayer.contents = maskImage!.CGImage
        colorArea.layer.mask = maskLayer
        return colorArea
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
