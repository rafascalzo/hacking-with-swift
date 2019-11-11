//
//  String.swift
//  TakingPicturesChallenge
//
//  Created by rafaeldelegate on 11/9/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import Foundation
import UIKit

//# Day: d, dd 31
//# Month: MM 09 MMM Sep MMMM September
//# Year: yyyy 2019
//# Hour: HH 12
//# Minutes: mm 45
//# Seconds: ss 47 ss.SS 47.11 ss.SSS 47.112
public enum DateFormat: String, CodingKey {
    // returns 2018-09-12T14:11:54+0000
    case yearMothDayTHourMinutesSeconds = "yyyy-MM-dd'T'HH:mm:ssZ"
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
    // return 10:45 PM
    case hourAndMinutesPMFormat = "h:mm a"
    // returns 10:45:54 +0000
    case hourMinutesSecondsAndZ = "HH:mm:ss Z"
}

extension Date {
    static func dateFrom(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
    
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
