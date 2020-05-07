//
//  AnalyticsEvents.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-23.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import Foundation

enum AnalyticsEvents: String {
    case loginWithApple = "loginWithApple"
    case signupWithApple = "signupWithApple"
    case loginWithEmail = "loginWithEmail"
    case signupWithEmail = "signupWithEmail"
    case createQR = "createQR"
    case scanQR = "scanQR"
    case signout = "signout"
}
