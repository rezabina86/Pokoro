//
//  Logger.swift
//  UbaarClient
//
//  Created by iOS Developer on 11/25/17.
//  Copyright © 2017 iOS Developer. All rights reserved.
//

import UIKit

class Logger: NSObject {
    
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSS"
    static var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    private class func sourceFileName(filePath : String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    class func log<T>(message : T , event : LogEvent , fileName : String = #file , line : Int = #line , column : Int = #column , funcname : String = #function) {
        
        #if DEBUG
            print("\(Date().toString()) \(event.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(column) \(funcname) -> \(message)")
        #endif
        
    }
    
}
