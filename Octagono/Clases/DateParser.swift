//
//  DateParser.swift
//  Octagono
//
//  Created by Christian Villa Rhode on 2/1/19.
//  Copyright © 2019 Christian Villa Rhode. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    func timeAgo() -> Int {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        return secondsAgo
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))

        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
            return "Hace \(secondsAgo) segundos"
        } else if secondsAgo < hour {
            return "Hace \(secondsAgo / minute) minutos"
        } else if secondsAgo < day {
            return "Hace \(secondsAgo / hour) horas"
        } else if secondsAgo < week {
            return "Hace \(secondsAgo / day) dias"
        }
        
        return "Hace \(secondsAgo / week) semanas"
    }
}

class DateParser{
    
    func DateParser(tempDate:NSString) -> String
    {
        let pastDate = Date(timeIntervalSince1970: (tempDate).doubleValue)
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: pastDate)
        return myStringafd
    }
    
    func CantidadDeSegundo(x:NSString) -> Int
    {
        let pastDate = Date(timeIntervalSince1970: x.doubleValue)
        return pastDate.timeAgo()
    }
    
    func IntervaloDeFecha(JsonNumber:NSString) -> String
    {
        let pastDate = Date(timeIntervalSince1970: JsonNumber.doubleValue)
        return pastDate.timeAgoDisplay()
    }
    
}
