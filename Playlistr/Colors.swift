//
//  Colors.swift
//  Playlistr
//
//  Created by Greg Azevedo on 11/17/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import Foundation

extension UIColor {
    
    class func NavBarColor() -> UIColor {
        return UIColor(hex: 0xE6E6E6, alpha:1)
    }

    class func ThemeColor() -> UIColor {
        return UIColor(hex: 0xC3E3AC, alpha:1)
    }

    convenience init(hex:Int, alpha:CGFloat) {
        self.init(red: (CGFloat)((hex & 0xFF0000) >> 16) / 255.0,
            green: (CGFloat)((hex & 0x00FF00) >> 8) / 255.0,
            blue: (CGFloat)((hex & 0x0000FF) >> 0) / 255.0,
            alpha: alpha)
    }

}