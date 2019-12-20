//
//  Text+Localize.swift
//  POKORO
//
//  Created by Reza Bina on 2019-11-24.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        let lang = Bundle.main.preferredLocalizations.first
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
}
