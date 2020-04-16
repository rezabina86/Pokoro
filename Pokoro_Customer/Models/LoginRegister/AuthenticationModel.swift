//
//  AuthenticationModel.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-15.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit
import Combine

class AuthenticationModel {
    
    private let type: AuthenticationType
    
    private var step: AuthenticationStep {
        willSet {
            isTextFieldSecure = newValue == .getPassword ? true : false
            askNextQuestion(step: newValue)
        }
    }
    
    public var messages: [LoginMessageModel] = [] {
        didSet { lastMessage = messages.last }
    }
    
    @Published var lastMessage: LoginMessageModel?
    
    @Published var isTextFieldSecure: Bool = false
    
    @Published var isUserAuthenticated: Bool = false
    
    private var email: EmailBusinessModel?
    
    private var name: NameBusinessModel?
    
    private var password: PasswordBusinessModel?
    
    init(type: AuthenticationType) {
        self.type = type
        self.step = .getEmail
    }
    
    public func start() {
        showMessageToUser(message: "loginWelcomeMessage".localized, isSecure: false, isUserInput: false) {
            self.step = .getEmail
        }
    }
    
    private func askNextQuestion(step: AuthenticationStep) {
        if type == .login {
            switch step {
            case .getEmail:
                showMessageToUser(message: "emailLoginMessage".localized, isSecure: false, isUserInput: false)
            case .getPassword:
                showMessageToUser(message: "getPasswordLoginMessage".localized, isSecure: false, isUserInput: false)
            case .done:
                showMessageToUser(message: "waitMessage".localized, isSecure: false, isUserInput: false, completion: {
                    self.authenticate()
                })
            default:
                break
            }
        } else {
            switch step {
            case .getEmail:
                showMessageToUser(message: "emailLoginMessage".localized, isSecure: false, isUserInput: false)
            case .getName:
                showMessageToUser(message: "getNameMessage".localized, isSecure: false, isUserInput: false)
            case .getPassword:
                showMessageToUser(message: "getPasswordRegisterMessage".localized, isSecure: false, isUserInput: false)
            case .done:
                showMessageToUser(message: "waitMessage".localized, isSecure: false, isUserInput: false, completion: {
                    self.authenticate()
                })
            }
        }
    }
    
    public func saveUserInput(_ message: String) {
        let userMessage = LoginMessageModel(message: message, isSecure: step == .getPassword ? true : false, isUserInput: true)
        messages.append(userMessage)
        switch step {
        case .getEmail:
            let emailModel = EmailBusinessModel(mail: message)
            if emailModel.isValid() {
                email = emailModel
                step.next(type: type)
            } else {
                email = nil
                showMessageToUser(message: "emailErrorMessage".localized, isSecure: false, isUserInput: false)
            }
        case .getName:
            let nameModel = NameBusinessModel(name: message)
            if nameModel.isValid() {
                name = nameModel
                step.next(type: type)
            } else {
                name = nil
                showMessageToUser(message: "nameErrorMessage".localized, isSecure: false, isUserInput: false)
            }
        case .getPassword:
            let passwordModel = PasswordBusinessModel(password: message)
            if passwordModel.isValid() {
                password = passwordModel
                step.next(type: type)
            } else {
                password = nil
                showMessageToUser(message: "passwordErrorMessage".localized, isSecure: false, isUserInput: false)
            }
        default:
            return
        }
    }
    
    private func showMessageToUser(message: String, isSecure: Bool, isUserInput: Bool, completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let message = LoginMessageModel(message: message, isSecure: isSecure, isUserInput: isUserInput)
            self.messages.append(message)
            completion?()
        }
    }
    
    private func restart() {
        email = nil
        password = nil
        name = nil
        isUserAuthenticated = false
        step = .getEmail
    }
    
    private func authenticate() {
        switch type {
        case .login:
            guard let email = email?.mail, let password = password?.password else { return }
            PKUserManager.shared.loginUserEmail(email: email, password: password) { [weak self] (success, error) in
                guard let self = self else { return }
                self.handleAPIResponse(success, error)
            }
        case .register:
            guard let email = email?.mail, let password = password?.password, let name = name?.name else { return }
            PKUserManager.shared.registerUserEmail(email: email, name: name, password: password) { [weak self] (success, error) in
                guard let self = self else { return }
                self.handleAPIResponse(success, error)
            }
        }
    }
    
    private func handleAPIResponse(_ success: Bool, _ error: String?) {
        if let error = error {
            showMessageToUser(message: error.localized, isSecure: false, isUserInput: false) {
                self.restart()
            }
        } else if success {
            showMessageToUser(message: "successLoginMessage".localized, isSecure: false, isUserInput: false) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isUserAuthenticated = true
                }
            }
        }
    }
    
}
