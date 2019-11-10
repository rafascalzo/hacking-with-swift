//
//  String.swift
//  TakingPicturesChallenge
//
//  Created by rafaeldelegate on 11/9/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import Foundation
import UIKit

//09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
//Sep 12, 2:11 PM                   --> MMM d, h:mm a
//September 2018                    --> MMMM yyyy
//Sep 12, 2018                      --> MMM d, yyyy
//Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
//2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
//12.09.18                          --> dd.MM.yy
//10:41:02.112                      --> HH:mm:ss.SSS

public enum DateFormat: String, CodingKey {
    // returns 31/12/1876
    case dayMonthAndYear = "dd/MM/yyyy"
    // returns 12/31/1876
    case monthDayAndYear = "MM/dd/yyy"
    // returns wednesday 12/31/1879
    case extendedDayOfTheWeekMonthDayAndYear = "EEEE MMM/d/yyyy"
    // returns jan/25/1876
    case literalShortMonthDayAndYear = "MMM/dd/yyyy"
    // returns 25/jan/1876
    case dayalphabeticalMonthAndYear = "dd/MMM/yyyy"
}

public enum TimeFormat: String, CodingKey {
    // return 10:41
    case hourAndMinutes = "HH:mm"
    // return 10:41:02
    case hourMinutesSeconds = "HH:mm:ss"
    // return 10:41:02.112
    case hourMinutesSecondsAndMiliseconds = "HH:mm:ss.SSS"
    // return 10:41:25 PM
    case hourMinutesSecondsPMFormat = "HH:mm:ss a"
    case hourAndMinutesPMFormat = "h:mm a"
}

extension Date {
    static func dateFrom(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
}

extension String {
    
    static func getHour(from date: Date, withFormat timeFormat: TimeFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = timeFormat.rawValue
        return formatter.string(from: date)
    }
    
    static func getStringDate(from date: Date, withFormat dateFormat: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.rawValue
        return formatter.string(from: date)
    }
    
    static func getRandomStringDate(from date: Date, withFormat dateFormat: DateFormat) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.rawValue
               let date = formatter.string(from: date)
               let components = date.components(separatedBy: "/")
        
        var day: String?
        var month: String?
        var year: String?
        var dayOfTheWeek:String?
        
        switch dateFormat {
       
        case .dayMonthAndYear:
            day = components[0]
            month = components[1]
            year = components[2]
        case .extendedDayOfTheWeekMonthDayAndYear:
            dayOfTheWeek = components[0]
            month = components[0]
            day = components[1]
            year = components[2]
        case .literalShortMonthDayAndYear:
            month = components[0]
            day = components[1]
            year = components[3]
        case .dayalphabeticalMonthAndYear:
            day = components[0]
            month = components[1]
            year = components[2]
        @unknown default:
            break
        }
        print(day)
               
        print(month)
        
               print(year)
               day = "\(Int.random(in: 1...31))"
               let fragmentDay = [dayOfTheWeek ?? "",day ?? "",month ?? "",year ?? ""]
               return fragmentDay.joined(separator: "/")
    }
    
}
