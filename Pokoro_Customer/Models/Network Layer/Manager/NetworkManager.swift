//
//  NetworkManager.swift
//  Ronaker
//
//  Created by Reza Bina on 9/10/18.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import Foundation
import UIKit

struct NetworkManager {
    
    #if DEBUG
        static let environment: NetworkEnvironment = .dev
    #else
        static let environment: NetworkEnvironment = .production
    #endif
    
    
    private let router = Router<RKApis>()
    
    enum NetworkResponse: String {
        case success
        case noNetwork = "noNetwork"
        case badRequest = "badRequest"
        case blocked = "blockedError"
        case failed = "failed"
        case noData = "noData"
        case unableToDecode = "unableToDecode"
    }
    
    enum Result<String> {
        case success
        case apiError
        case failure(String)
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 400...499: return .apiError
        case 500...599: return .failure(NetworkResponse.badRequest.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    fileprivate func handleErrors(data: Data?, result: Result<String>) -> String? {
        switch result {
        case .apiError:
            guard let responseData = data else { return NetworkResponse.noData.rawValue }
            do {
                let result = try JSONDecoder().decode(ErrorBusinessModel.self, from: responseData)
                return result.detail
            } catch { return NetworkResponse.unableToDecode.rawValue }
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
    
//    func login(request: LoginBusinessModel.Fetch.Request, completion: @escaping (_ result: LoginBusinessModel.Fetch.Response?, _ error: String?) -> ()) {
//        router.request(.login(model: request)) { (data, response, error) in
//            if error != nil { completion(nil, NetworkResponse.noNetwork.rawValue) }
//            if let response = response as? HTTPURLResponse {
//                let result = self.handleNetworkResponse(response)
//                switch result {
//                case .success:
//                    guard let responseData = data else {
//                        completion(nil, NetworkResponse.noData.rawValue)
//                        return
//                    }
//                    do {
//                        let result = try JSONDecoder().decode(LoginBusinessModel.Fetch.Response.self, from: responseData)
//                        completion(result, nil)
//                    } catch {
//                        Logger.log(message: error, event: LogEvent.error)
//                        completion(nil, NetworkResponse.unableToDecode.rawValue)
//                    }
//                default:
//                    let error = self.handleErrors(data: data, result: result)
//                    completion(nil, error)
//                }
//            }
//        }
//    }
    
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
