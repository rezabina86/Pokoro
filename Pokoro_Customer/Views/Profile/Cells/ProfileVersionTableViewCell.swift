//
//  ProfileVersionTableViewCell.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-11.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class ProfileVersionTableViewCell: UITableViewCell {
    
    private let versionLabel: MediumSB = {
        let label = MediumSB()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "POKORO version \(PKUserManager.shared.appVersion) (\(PKUserManager.shared.buildVersion))"
        return label
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(versionLabel)
        versionLabel.topAnchor.constraint(equalTo: safeTopAnchor, constant: 12).isActive = true
        versionLabel.centerXAnchor.constraint(equalTo: safeCenterXAnchor, constant: 0).isActive = true
        versionLabel.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: 0).isActive = true
    }

}
