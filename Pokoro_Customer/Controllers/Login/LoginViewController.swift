//
//  LoginViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-16.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private let continueButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .continue, style: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.cornerRadius = 25
        return button
    }()
    
    private let continueWithEmailButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 25
        btn.clipsToBounds = true
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1.0
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("Sign up with email", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return btn
    }()
    
    private let loginWithEmailButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("Already have an account? Sign in with your email", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        return btn
    }()
    
    private let logoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "logo"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let welcomeMessageLabel: LargeLight = {
        let label = LargeLight()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "loginWelcome".localized
        label.textAlignment = .center
        label.textColor = UIColor.PKColors.navy
        return label
    }()
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "logoBack"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        //performExistingAccountSetupFlows()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.PKColors.lightGreen
        
        loginWithEmailButton.addTarget(self, action: #selector(loginWithEmailButtonDidTap(_:)), for: .touchUpInside)
        view.addSubview(loginWithEmailButton)
        loginWithEmailButton.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -12).isActive = true
        loginWithEmailButton.centerXAnchor.constraint(equalTo: view.safeCenterXAnchor, constant: 0).isActive = true
        
        continueWithEmailButton.addTarget(self, action: #selector(registerWithEmailButtonDidTap(_:)), for: .touchUpInside)
        view.addSubview(continueWithEmailButton)
        continueWithEmailButton.bottomAnchor.constraint(equalTo: loginWithEmailButton.topAnchor, constant: -12).isActive = true
        continueWithEmailButton.centerXAnchor.constraint(equalTo: view.safeCenterXAnchor, constant: 0).isActive = true
        continueWithEmailButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        continueWithEmailButton.widthAnchor.constraint(equalToConstant: 260).isActive = true
        
        continueButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        view.addSubview(continueButton)
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: 260).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: continueWithEmailButton.topAnchor, constant: -12).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        view.addSubview(logoImageView)
        logoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -250).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.safeCenterXAnchor, constant: 0).isActive = true
        
        view.addSubview(welcomeMessageLabel)
        welcomeMessageLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 8).isActive = true
        welcomeMessageLabel.centerXAnchor.constraint(equalTo: view.safeCenterXAnchor, constant: 0).isActive = true
        welcomeMessageLabel.widthAnchor.constraint(equalToConstant: 260).isActive = true
        
        view.addSubview(backgroundImageView)
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 50).isActive = true
        backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 0.57).isActive = true
    }
    
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc
    private func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc
    private func loginWithEmailButtonDidTap(_ sender: UIButton) {
        let controller = PKLoginChatViewController()
        controller.authenticationModel = AuthenticationModel(type: .login)
        controller.delegate = self
        controller.isModalInPresentation = true
        present(controller, animated: true)
    }
    
    @objc
    private func registerWithEmailButtonDidTap(_ sender: UIButton) {
        let controller = PKLoginChatViewController()
        controller.authenticationModel = AuthenticationModel(type: .register)
        controller.delegate = self
        controller.isModalInPresentation = true
        present(controller, animated: true)
    }
    
    private func checkLogin() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.presentAuthenticationCoordinator()
    }

}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            PKUserManager.shared.checkCredential(appleIDCredential, completion: { [weak self] (success, error) in
                guard let `self` = self else { return }
                if let error = error {
                    self.showAlert(message: error.localized, type: .error)
                } else if success {
                    self.checkLogin()
                }
            })
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension LoginViewController: PKLoginChatViewControllerDelegate {
    
    func pkLoginChatViewControllerUserIsAuthenticated(_ controller: PKLoginChatViewController) {
        controller.dismiss(animated: true) {
            self.checkLogin()
        }
    }
    
    func pkLoginChatViewControllerCloseButtonDidTap(_ controller: PKLoginChatViewController) {
        controller.dismiss(animated: true)
    }
    
}
