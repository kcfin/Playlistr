//
//  SPTParser.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/29/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import Foundation

class SPTParser {
    
    func parseSPTUser(sptUser: SPTUser) {
        do {
            let urlString = try String(contentsOfURL: sptUser.largestImage.imageURL);
            user.initAndSaveUser(withName: sptUser.displayName, withImageURL: urlString);
            NSNotificationCenter.defaultCenter().postNotificationName("InitializeUser", object: self);
        } catch let error as NSError! {
            print("Could not convert user image URL to string: \(error)")
        }
    }
}