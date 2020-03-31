//
//  PKUserManager.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-16.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit
import OneSignal
import AuthenticationServices

class PKUserManager: NSObject {
    
    typealias credentialHandler = (_ success: Bool, _ error: String?) -> Void
    
    static let shared = PKUserManager()
    
    public var token: String? {
        set { UserDefaults.standard.set(newValue, forKey: "token") }
        get { return UserDefaults.standard.value(forKey: "token") as? String }
    }
    
    public var userId: String? {
        set { UserDefaults.standard.set(newValue, forKey: "userId") }
        get { return UserDefaults.standard.value(forKey: "userId") as? String }
    }
    
    public var name: String? {
        set { UserDefaults.standard.set(newValue, forKey: "name") }
        get { return UserDefaults.standard.value(forKey: "name") as? String }
    }
    
    public var isUserLoggedIn: Bool {
        get { return token != nil }
    }
    
    public func clearDataOnLogout() {
        token = nil
    }
    
    func checkCredential(_ credential: ASAuthorizationAppleIDCredential, completion: @escaping credentialHandler) {
        let userIdentifier = credential.user
        if let name = credential.fullName, let email = credential.email {
            registerUser(userIdentifier: userIdentifier, email: email, name: "\(name.givenName ?? "") \(name.familyName ?? "")") { (success, error) in
                completion(success, error)
            }
        } else {
            loginUser(userIdentifier: userIdentifier) { (success, error) in
                completion(success, error)
            }
        }
    }
    
}

extension PKUserManager {
    
    private func loginUser(userIdentifier: String, completion: @escaping credentialHandler) {
        NetworkManager().login(request: LoginBusinessModel.Fetch.Request(ios_user_identifier: userIdentifier)) { [weak self] (result, error) in
            guard let `self` = self else { return }
            if let error = error {
                completion(false, error)
            } else if let result = result {
                self.userId = result.id
                self.token = result.token
                self.name = result.name
                OneSignal.sendTag("user_id", value: result.id)
                completion(true, nil)
            }
        }
    }
    
    private func registerUser(userIdentifier: String, email: String, name: String, completion: @escaping credentialHandler) {
        NetworkManager().registerUser(request: RegisterBusinessModel.Fetch.Request(email: email, name: name, ios_user_identifier: userIdentifier)) { (result, error) in
            if let error = error {
                completion(false, error)
            } else if let result = result {
                self.userId = result.id
                self.token = result.token
                self.name = result.name
                OneSignal.sendTag("user_id", value: result.id)
                completion(true, nil)
            }
        }
    }
    
}
