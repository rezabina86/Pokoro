//
//  Date+Components.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-01.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import Foundation

extension Date {
    
    var stringFormat: String? {
        let numberOfdays = Date() - self
        guard let days = numberOfdays.day else { return nil }
        if days == 0 {
            return "Today \(self.hour):\(self.minute < 10 ? "0\(self.minute)" : "\(self.minute)")"
        } else if days == 1 {
            return "Yesterday, \(self.hour):\(self.minute < 10 ? "0\(self.minute)" : "\(self.minute)")"
        } else if days >= 365 {
            return "\(self.year) \(convertMonths(month: self.month)), \(self.day)   \(self.hour):\(self.minute < 10 ? "0\(self.minute)" : "\(self.minute)")"
        } else {
            return "\(convertMonths(month: self.month)), \(self.day)   \(self.hour):\(self.minute < 10 ? "0\(self.minute)" : "\(self.minute)")"
        }
    }
    
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?) {
        
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: recent)
        let date2 = calendar.startOfDay(for: previous)
        
        let diff = calendar.dateComponents([.month, .day, .hour, .minute], from: date2, to: date1)
        return (month: diff.month, day: diff.day, hour: diff.hour, minute: diff.minute)
    }
    
    private func convertMonths(month : Int) -> String {
        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return ""
        }
    }
    
    var year: Int {
        return Calendar(identifier: .gregorian).component(.year, from: self)
    }
    
    var month: Int {
        return Calendar(identifier: .gregorian).component(.month, from: self)
    }
    
    var day: Int {
        return Calendar(identifier: .gregorian).component(.day, from: self)
    }
    
    var hour: Int {
        return Calendar(identifier: .gregorian).component(.hour, from: self)
    }
    
    var minute: Int {
        return Calendar(identifier: .gregorian).component(.minute, from: self)
    }
    
}
