//
//  AppDelegate.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/20/15.
//  Copyright (c) 2015 Katelyn Findlay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let authenticator = SpotifyAuthenticator();
    let kClientId = "3d912a8a1aa64b11b07abeecc30df390"
    let kCallbackURL = "playlistr-login://callback"
    let kTokenSwapURL = "http://localhost:1234/swap"
    
    var session:SPTSession?
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let auth = SPTAuth.defaultInstance();
//        let loginURL = auth.loginURL;
        auth.clientID = kClientId;
        auth.requestedScopes = [SPTAuthStreamingScope];
        auth.redirectURL = NSURL(string: kCallbackURL);

        window = UIWindow(frame: UIScreen.mainScreen().bounds);
        window?.makeKeyAndVisible();
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let loginVC = storyboard.instantiateViewControllerWithIdentifier("LoginVC");
        
        if(auth.session == nil || !auth.session.isValid()){
            window?.rootViewController = loginVC;
        } else {
            window?.rootViewController = storyboard.instantiateInitialViewController();
        }
                
        return true;
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
//        var canAuthenticate: Bool = false;
        if(SPTAuth.defaultInstance().canHandleURL(url)) {
            SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, callback: { (error, session) -> Void in
                if(error != nil) {
                    print("*** Auth error: \(error)")
                    return;
                }
                
            });
        }
        return false;
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

