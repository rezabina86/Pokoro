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
        let days = daysBetweenDates(startDate: self, endDate: Date())
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
    
    private func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        guard let start = calendar.ordinality(of: .day, in: .era, for: startDate) else { return 0 }
        guard let end = calendar.ordinality(of: .day, in: .era, for: endDate) else { return 0 }
        return end - start
    }
    
    private func convertMonths(month : Int) -> String {
        switch month {
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
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
