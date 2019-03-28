//
//  DateManager.swift
//  ChatApp
//
//  Created by Jatin on 23/01/17.
//  Copyright © 2017 Jatin. All rights reserved.
//

import UIKit

class DateManager: NSObject {
    class func dateFrom (string: String,withFormat:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = withFormat
        let date = dateFormatter.date(from: string)
        return date!
    }
    
    class func stringFrom (date : Date , inFormat : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = inFormat
        dateFormatter.timeZone = NSTimeZone.local
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func convertDobToAge (dobString: String , inFormat: String ) -> String {
        let userCalendar = NSCalendar.current
        
        let date = DateManager.dateFrom(string: dobString, withFormat: inFormat)
        let dateNow  = NSDate()
        let ageComponents = userCalendar.dateComponents([.year], from: date, to: dateNow as Date)
        let age = ageComponents.year
        return age!.description
    }
    
    class func get12HrTimeFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current

        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: date)
    }

}
