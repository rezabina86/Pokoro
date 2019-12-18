//
//  LogEvent.swift
//  UbaarClient
//
//  Created by iOS Developer on 11/25/17.
//  Copyright © 2017 iOS Developer. All rights reserved.
//

import Foundation

enum LogEvent : String {
    case error = "[‼️]" // error
    case info = "[ℹ️]" // info
    case debug = "[💬]" // debug
    case verbose = "[🔬]" // verbose
    case warning = "[⚠️]" // warning
    case severe = "[🔥]" // severe
}
