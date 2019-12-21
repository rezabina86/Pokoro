//
//  LoginViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-16.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let noticeLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        test()
    }
    
    private func setupViews() {
        view.backgroundColor = ThemeManager.shared.theme?.primaryColor
        
        view.addSubview(noticeLabel)
        noticeLabel.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -16).isActive = true
        noticeLabel.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 42).isActive = true
        noticeLabel.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -42).isActive = true
        noticeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func test() {
        let plainAttributedString = NSMutableAttributedString(string: "noticeWelcome".localized, attributes: [NSAttributedString.Key.foregroundColor : (ThemeManager.shared.theme?.textColor)!, NSAttributedString.Key.font : UIFont.PKFonts.MediumSB])
    
        let attributedLinkString = NSMutableAttributedString(string: "terms".localized, attributes:[NSAttributedString.Key.link: URL(string: "http://www.google.com")!, NSAttributedString.Key.foregroundColor : UIColor.blue, NSAttributedString.Key.font : UIFont.PKFonts.MediumSB])
        
        let plainAttributedString1 = NSMutableAttributedString(string: "and".localized, attributes: [NSAttributedString.Key.foregroundColor : (ThemeManager.shared.theme?.textColor)!, NSAttributedString.Key.font : UIFont.PKFonts.MediumSB])
        
        let attributedLinkString1 = NSMutableAttributedString(string: "policy".localized, attributes:[NSAttributedString.Key.link: URL(string: "http://www.google.com")!, NSAttributedString.Key.foregroundColor : UIColor.blue, NSAttributedString.Key.font : UIFont.PKFonts.MediumSB])
        
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

}
