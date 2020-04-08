//
//  ObjectConvertible.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-06.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import Foundation

/// An object that wants to be convertible in a managed object should implement the `ObjectConvertible` protocol.
protocol ObjectConvertible {
    /// An identifier that is used to fetch the corresponding database object.
    var identifier: String? { get }
}
