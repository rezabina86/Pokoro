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
        avatarView.topAnchor.constraint(equalTo: safeTopAnchor, constant: 24).isActive = true
        avatarView.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -24).isActive = true
        avatarView.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 24).isActive = true
        avatarView.widthAnchor.constraint(equalToConstant: 72).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: safeTopAnchor, constant: 24).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -24).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -24).isActive = true
    }

}
