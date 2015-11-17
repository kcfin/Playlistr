//
//  NavigationController.swift
//  Playlistr
//
//  Created by Greg Azevedo on 11/17/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func loadView() {
        super.loadView()
        navigationBar.barTintColor = UIColor.NavBarColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationBar.tintColor = UIColor.whiteColor()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
