//
//  AuthenticationStep.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-15.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import Foundation

enum AuthenticationStep {
    case getEmail
    case getName
    case getPassword
    case done
}

extension AuthenticationStep {
    
    mutating func next(type: AuthenticationType) {
        switch type {
        case .login:
            loginNext()
        case .register:
            registerNext()
        }
    }
    
    private mutating func loginNext() {
        switch self {
        case .getEmail:
            self = .getPassword
        case .getPassword:
            self = .done
        default:
            break
        }
    }
    
    private mutating func registerNext() {
        switch self {
        case .getEmail:
            self = .getName
        case .getName:
            self = .getPassword
        case .getPassword:
            self = .done
        default:
            break
        }
    }
    
}
