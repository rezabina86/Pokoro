//
//  URLParametersEncoder.swift
//  NetworkLayer
//
//  Created by Reza Bina on 18/08/2019.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import Foundation

public struct URLParametersEncoder: URLEncoder {
    
    public static func encode(urlRequest: inout URLRequest, with paramenters: Parameters) throws {
        guard let url = urlRequest.url else { throw NetworkError.missingURL }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !paramenters.isEmpty {
            urlComponents.queryItems = []
            for (key, value) in paramenters {
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
    }
    
}
