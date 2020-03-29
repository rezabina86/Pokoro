//
//  Array+difference.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-29.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
