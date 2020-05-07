//
//  StorageErrors.swift
//  TESTTSET
//
//  Created by Reza Bina on 2020-05-06.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import Foundation

enum StorageError: Error {
    case notFound
    case cantWrite(Error)
}
