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
    
    private let logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "logo_50")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        selectionStyle = .none
        
        addSubview(versionLabel)
        versionLabel.topAnchor.constraint(equalTo: safeTopAnchor, constant: 12).isActive = true
        versionLabel.centerXAnchor.constraint(equalTo: safeCenterXAnchor, constant: 0).isActive = true
        
        addSubview(logoImageView)
        logoImageView.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 4).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: safeCenterXAnchor, constant: 0).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -4).isActive = true
    }

}
