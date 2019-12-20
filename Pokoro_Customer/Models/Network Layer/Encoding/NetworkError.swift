//
//  NetworkError.swift
//  NetworkLayer
//
//  Created by Reza Bina on 18/08/2019.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import Foundation

public enum NetworkError: String, Error {
    case parametersNil  = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL     = "URL is nil"
}
