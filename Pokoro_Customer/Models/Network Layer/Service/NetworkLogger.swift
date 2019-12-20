//
//  NetworkLogger.swift
//  Networking
//
//  Created by Reza Bina on 22/08/2019.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import Foundation

class NetworkLogger {
    
    static func log(request: URLRequest) {
        
        #if DEBUG
        print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer{ print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        #endif
        
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        request.allHTTPHeaderFields?.forEach({ (key, value) in
            logOutput += "\(key): \(value) \n"
        })
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        #if DEBUG
        print(logOutput)
        #endif
    }
    
    static func log(response: HTTPURLResponse?, data: Data?) {
        guard let response = response else { return }
        
        #if DEBUG
        print("\n - - - - - - - - - - INCOMING - - - - - - - - - - \n")
        defer{ print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        #endif
        
        let statusCode = response.statusCode
        
        var logOutput = """
        \n
        STATUS CODE : \(statusCode) \n
        """
        
        for (key,value) in response.allHeaderFields {
            if let key = key as? String, key == "Date" {
                logOutput += "\(key): \(value) \n"
            }
        }
        
        if let data = data {
            logOutput += "\n \(NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        #if DEBUG
        print(logOutput)
        #endif
        
    }
    
}
