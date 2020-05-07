//
//  Analytic.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-23.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import FirebaseAnalytics

class Analytic: NSObject {
    
    static func sendLog(_ event: AnalyticsEvents) {
        Analytics.logEvent(event.rawValue, parameters: nil)
    }
    
}
