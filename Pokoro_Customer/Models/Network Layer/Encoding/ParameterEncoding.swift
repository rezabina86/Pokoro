//
//  ParameterEncoding.swift
//  NetworkLayer
//
//  Created by Reza Bina on 18/08/2019.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import Foundation

public typealias Parameters = [String : Any]

public protocol JSONBodyEncoder {
    static func encode(urlRequest: inout URLRequest, with bodyModel: Encodable) throws
}

public protocol URLEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}



