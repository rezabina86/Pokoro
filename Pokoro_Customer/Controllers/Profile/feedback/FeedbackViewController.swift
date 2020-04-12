//
//  FeedbackViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-11.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit
import MessageUI

class FeedbackViewController: UIViewController {

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "feedbackArtwork")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: H2 = {
        let view = H2()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.PKColors.navy
        view.text = "feedbackTitle".localized
        view.textAlignment = .center
        return view
    }()
    
    private let bodyLabel: LargeRegular = {
        let view = LargeRegular()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.PKColors.ashGrey
        view.textAlignment = .center
        view.text = "feedbackBody".localized
        return view
    }()
    
    private let button: PKButton = {
        let btn = PKButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Share", for: .normal)
        return btn
    }()
    
    private var skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.setTitleColor(UIColor.PKColors.navy, for: .normal)
        button.layer.zPosition = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: view.safeCenterYAnchor, constant: -72).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.safeCenterXAnchor, constant: 0).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 36).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 28).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -28).isActive = true
        
        view.addSubview(bodyLabel)
        bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24).isActive = true
        bodyLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -24).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 28).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -28).isActive = true
        
        button.addTarget(self, action: #selector(shareButtonDidTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
        button.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -16).isActive = true
        button.centerXAnchor.constraint(equalTo: view.safeCenterXAnchor, constant: 0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        skipButton.addTarget(self, action: #selector(skipButtonDidTapped(_:)), for: .touchUpInside)
        view.addSubview(skipButton)
        skipButton.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 12).isActive = true
        skipButton.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -28).isActive = true
    }
    
    @objc private func skipButtonDidTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc private func shareButtonDidTapped(_ sender: UIButton) {
        sendEmail()
    }
    
    func sendEmail() {
        let emailAddress = "info@pokoro.app"
        let subject = "Feedback about Pokoro app"
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([emailAddress])
            mail.setSubject(subject)

            present(mail, animated: true)
        } else if let mailURL = createEmailUrl(to: emailAddress, subject: subject, body: "") {
            UIApplication.shared.open(mailURL, options: [:])
        }
    }

}

extension FeedbackViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        if result == .sent {
            dismiss(animated: true)
        }
    }
    
}

extension FeedbackViewController {
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }

        return defaultUrl
    }
    
}
