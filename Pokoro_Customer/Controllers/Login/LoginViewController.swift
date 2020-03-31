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
    
    private let noticeLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    private let continueButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .continue, style: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.cornerRadius = 5
        return button
    }()
    
    private let logoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "logo"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let welcomeMessageLabel: LargeRegular = {
        let label = LargeRegular()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "loginWelcome".localized
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        noticeText()
        performExistingAccountSetupFlows()
    }
    
    private func setupViews() {
        view.backgroundColor = ThemeManager.shared.theme?.primaryColor
        
        view.addSubview(noticeLabel)
        noticeLabel.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -12).isActive = true
        noticeLabel.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 24).isActive = true
        noticeLabel.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -24).isActive = true
        noticeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        continueButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        view.addSubview(continueButton)
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: noticeLabel.topAnchor, constant: -8).isActive = true
        continueButton.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 24).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -24).isActive = true
        
        view.addSubview(logoImageView)
        logoImageView.centerYAnchor.constraint(equalTo: view.safeCenterYAnchor, constant: -24).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.safeCenterXAnchor, constant: 0).isActive = true
        
        view.addSubview(welcomeMessageLabel)
        welcomeMessageLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 8).isActive = true
        welcomeMessageLabel.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 24).isActive = true
        welcomeMessageLabel.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -24).isActive = true
    }
    
    private func noticeText() {
        let font = UIFont.PKFonts.MediumRegular
        let termsURL = URL(string: "http://www.google.com")!
        let policyURL = URL(string: "http://www.google.com")!
        
        let plainAttributedString = NSMutableAttributedString(string: "noticeWelcome".localized, attributes: [NSAttributedString.Key.foregroundColor : (ThemeManager.shared.theme?.textColor)!, NSAttributedString.Key.font : font])
    
        let attributedLinkString = NSMutableAttributedString(string: "terms".localized, attributes:[NSAttributedString.Key.link: termsURL, NSAttributedString.Key.foregroundColor : UIColor.blue, NSAttributedString.Key.font : font])
        
        let plainAttributedString1 = NSMutableAttributedString(string: "and".localized, attributes: [NSAttributedString.Key.foregroundColor : (ThemeManager.shared.theme?.textColor)!, NSAttributedString.Key.font : font])
        
        let attributedLinkString1 = NSMutableAttributedString(string: "policy".localized, attributes:[NSAttributedString.Key.link: policyURL, NSAttributedString.Key.foregroundColor : UIColor.blue, NSAttributedString.Key.font : font])
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let fullAttributedString = NSMutableAttributedString()
        fullAttributedString.append(plainAttributedString)
        fullAttributedString.append(attributedLinkString)
        fullAttributedString.append(plainAttributedString1)
        fullAttributedString.append(attributedLinkString1)
        fullAttributedString.addAttributes([NSAttributedString.Key.paragraphStyle: style], range: NSMakeRange(0, fullAttributedString.length))
        
        noticeLabel.isUserInteractionEnabled = true
        noticeLabel.isEditable = false
        noticeLabel.attributedText = fullAttributedString
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
