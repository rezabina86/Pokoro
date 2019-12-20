//
//  JSONParameterEncoder.swift
//  NetworkLayer
//
//  Created by Reza Bina on 18/08/2019.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import Foundation

public struct JSONParameterEncoder: JSONBodyEncoder {
    
    public static func encode(urlRequest: inout URLRequest, with bodyModel: Encodable) throws {
        do {
            let requestEncodable = AnyEncodable(bodyModel)
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(Formatter.iso8601)
            let jsonAsData = try encoder.encode(requestEncodable)
            urlRequest.httpBody = jsonAsData
        } catch {
            throw NetworkError.encodingFailed
        }
    }
    
    struct AnyEncodable: Encodable {
        var _encodeFunc: (Encoder) throws -> Void
        
        init(_ encodable: Encodable) {
            func _encode(to encoder: Encoder) throws {
                try encodable.encode(to: encoder)
            }
            self._encodeFunc = _encode
        }
        func encode(to encoder: Encoder) throws {
            try _encodeFunc(encoder)
        }
    }
    
}
