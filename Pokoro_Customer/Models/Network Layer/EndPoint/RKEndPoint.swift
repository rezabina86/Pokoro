//
//  TMEndPoint.swift
//  Ronaker
//
//  Created by Reza Bina on 9/10/18.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import Foundation
import UIKit

enum NetworkEnvironment {
    case production
    case dev
}

enum RKApis {
    case login(model: LoginBusinessModel.Fetch.Request)
}

extension RKApis: EndPointType {
    
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .production: return "https://api.ronaker.com/api/v1"
        case .dev: return "https://api.ronaker.com/api/v1"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .login(_): return "/users/token_auth/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .login(_): return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .login(let model):
            return .requestParameters(bodyParameters: model, urlParameters: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        var headers: [String: String] = [:]
        if let token = PKUserManager.shared.token {
            headers["Authorization"] = "Token \(token)"
        }
        return headers
    }
    
}










