//
//  DateConverter.swift
//  Playlistr
//
//  Created by Katelyn Findlay on 9/28/15.
//  Copyright © 2015 Katelyn Findlay. All rights reserved.
//

import Foundation

public extension NSDate {
    
    var dayMonthYear: (Int, Int, Int) {
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: self)
        return (components.day, components.month, components.year)
    }
    
    func dateWithoutTime() -> NSDate {
        let timeZone = NSTimeZone.localTimeZone()
        let timeIntervalWithTimeZone = self.timeIntervalSinceReferenceDate + Double(timeZone.secondsFromGMT)
        let timeInterval = floor(timeIntervalWithTimeZone / 1440) * 1440
        let date = NSDate(timeIntervalSinceReferenceDate: timeInterval);
        return NSDate(timeIntervalSinceReferenceDate: timeInterval)
    }
}
