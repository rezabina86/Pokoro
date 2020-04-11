//
//  ProfileHeaderTableViewCell.swift
//  Ronaker-Customer
//
//  Created by Reza Bina on 27/07/2019.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit
//import M13ProgressSuite

class ProfileHeaderTableViewCell: UITableViewCell {
    
    private let avatarView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 36
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.layer.borderWidth = 1
        view.image = UIImage(named: "Man")
        return view
    }()
    
    private let nameLabel: H2 = {
        let label = H2()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = PKUserManager.shared.name
        return label
    }()
    
    private let emailLabel: SmallSB = {
        let label = SmallSB()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = PKUserManager.shared.email
        return label
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        addSubview(avatarView)
        avatarView.centerYAnchor.constraint(equalTo: safeCenterYAnchor, constant: 0).isActive = true
        avatarView.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 24).isActive = true
        avatarView.widthAnchor.constraint(equalToConstant: 72).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: safeTopAnchor, constant: 36).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -24).isActive = true
        
        addSubview(emailLabel)
        emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        emailLabel.bottomAnchor.constraint(lessThanOrEqualTo: safeBottomAnchor, constant: -12).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -24).isActive = true
    }

}
