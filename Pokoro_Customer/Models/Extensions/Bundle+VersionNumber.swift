//
//  Bundle+VersionNumber.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-11.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
