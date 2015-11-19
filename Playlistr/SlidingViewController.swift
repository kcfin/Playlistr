//
//  SlidingViewController.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 11/18/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import UIKit
import ECSlidingViewController
import DOHamburgerButton

class SlidingViewController: ECSlidingViewController {

    var menuVC: UIViewController?;
    var hamburger: DOHamburgerButton?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlider();
    }
    
    func setupSlider() {
        menuVC = UIViewController();
        menuVC?.view.backgroundColor = UIColor.whiteColor();
        menuVC?.view.layer.borderWidth = 20;
        menuVC?.view.layer.borderColor = UIColor.lightGrayColor().CGColor;
                
        underLeftViewController = menuVC;
        anchorLeftPeekAmount = 200;
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
