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
    case loginWithEmail(model: LoginBusinessModel.Fetch.RequestWithEmail)
    case registerUserWithEmail(model: RegisterBusinessModel.Fetch.RequestWithEmail)
    case login(model: LoginBusinessModel.Fetch.Request)
    case registerUser(model: RegisterBusinessModel.Fetch.Request)
    case getNameSpaces(model: NameSpacesBusinessModel.Fetch.Request)
    case checkNameSpace(model: CheckNamespaceBusinessModel.Fetch.Request)
    case getChats
    case getThread(model: ThreadBusinessModel.Fetch.Request)
    case createNamespace(model: CreateNamespaceBusinessModel.Fetch.Request)
}

extension RKApis: EndPointType {
    
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .production: return Server.apiURL.absoluteString
        case .dev: return Server.apiURL.absoluteString
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .loginWithEmail(_): return "/users/login/"
        case .registerUserWithEmail(_) : return "/users/"
        case .login(_): return "/users/login/"
        case .registerUser(_) : return "/users/"
        case .getNameSpaces(_): return "/namespaces"
        case .checkNameSpace(let model): return "/namespaces/\(model.id)"
        case .getChats: return "/chats"
        case .getThread(let model): return "/chats/\(model.id)"
        case .createNamespace(_): return "/namespaces/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .loginWithEmail(_): return .post
        case .registerUserWithEmail(_): return .post
        case .login(_): return .post
        case .registerUser(_): return .post
        case .getNameSpaces(_): return .get
        case .checkNameSpace(_): return .get
        case .getChats: return .get
        case .getThread(_): return .get
        case .createNamespace(_): return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .loginWithEmail(let model):
                return .requestParameters(bodyParameters: model, urlParameters: nil)
        case .registerUserWithEmail(let model):
                return .requestParameters(bodyParameters: model, urlParameters: nil)
        case .login(let model):
            return .requestParameters(bodyParameters: model, urlParameters: nil)
        case .registerUser(let model):
            return .requestParameters(bodyParameters: model, urlParameters: nil)
        case .getNameSpaces(let model):
            return .requestParameters(bodyParameters: nil, urlParameters: model.parameters)
        case .checkNameSpace(_):
            return .request
        case .getChats:
            return .request
        case .getThread(let model):
            return .requestParameters(bodyParameters: nil, urlParameters: model.parameters)
        case .createNamespace(let model):
            return .requestParameters(bodyParameters: model, urlParameters: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        var headers: [String: String] = [:]
        if let token = PKUserManager.shared.token {
            headers["session"] = token
        }
        return headers
    }
    
}










