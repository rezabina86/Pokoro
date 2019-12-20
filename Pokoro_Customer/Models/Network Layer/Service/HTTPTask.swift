//
//  HTTPTask.swift
//  NetworkLayer
//
//  Created by Reza Bina on 18/08/2019.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String : String]

public enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Encodable?, urlParameters: Parameters?)
    case requestParametersAndHeaders(bodyParameters: Encodable?, urlParameters: Parameters?, additionalHeaders: Parameters?)
}
