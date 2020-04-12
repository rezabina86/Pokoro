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
import Combine

class PKUserManager: NSObject, ObservableObject {
    
    typealias credentialHandler = (_ success: Bool, _ error: String?) -> Void
    
    @Published var isAppInForeground: Bool = true
    @Published var pushNotificationChatId: String?
    
    static let shared = PKUserManager()
    public var chatManager: PkChatManager<ChatThread<ChatMessage>, ChatMessage>?
    
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
    
    public var email: String? {
        set { UserDefaults.standard.set(newValue, forKey: "email") }
        get { return UserDefaults.standard.value(forKey: "email") as? String }
    }
    
    var buildVersion: String {
        guard let version = Bundle.main.buildVersionNumber else { return "" }
        return version
    }
    
    var appVersion: String {
        guard let version = Bundle.main.releaseVersionNumber else { return "" }
        return version
    }
    
    public var isWalkthroughShown: Bool {
        set { UserDefaults.standard.set(newValue, forKey: "walkthrough") }
        get { return UserDefaults.standard.value(forKey: "walkthrough") as? Bool ?? false }
    }
    
    public var isUserLoggedIn: Bool {
        get { return token != nil }
    }
    
    public func clearDataOnLogout() {
        token = nil
        userId = nil
        name = nil
        email = nil
        OneSignal.deleteTag("user_id")
        NamespacesCacheManager.shared.clear()
        ThreadsCacheManager.shared.clear()
        chatManager?.disconnect()
        chatManager?.deleteMessages()
        pushNotificationChatId = nil
        isWalkthroughShown = false
    }
    
    func checkCredential(_ credential: ASAuthorizationAppleIDCredential, completion: @escaping credentialHandler) {
        let userIdentifier = credential.user
        if let name = credential.fullName, let email = credential.email {
            registerUser(userIdentifier: userIdentifier, email: email, name: "\(name.givenName ?? "") \(name.familyName ?? "")") { [weak self] (success, error) in
                guard let `self` = self else { return }
                if error != nil {
                    self.loginUser(userIdentifier: userIdentifier) { (success, error) in
                        completion(success,error)
                    }
                } else {
                    completion(success, nil)
                }
            }
        } else {
            loginUser(userIdentifier: userIdentifier) { (success, error) in
                completion(success, error)
            }
        }
    }
    
    private func registerOneSignal() {
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            if let user_id = PKUserManager.shared.userId {
                OneSignal.sendTag("user_id", value: user_id)
            }
        })
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
                self.email = result.email.address
                OneSignal.sendTag("user_id", value: result.id)
                completion(true, nil)
                self.registerOneSignal()
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
                self.email = result.email.address
                OneSignal.sendTag("user_id", value: result.id)
                completion(true, nil)
                self.registerOneSignal()
            }
        }
    }
    
}
