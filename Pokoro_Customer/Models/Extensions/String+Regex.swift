//
//  String+Regex.swift
//  POKORO
//
//  Created by Reza Bina on 2019-11-24.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import Foundation

extension String {
    func isValid(regex : String) -> Bool {
        let Format = regex
        let Predicate = NSPredicate(format:"SELF MATCHES %@", Format)
        return Predicate.evaluate(with: self)
    }
}
