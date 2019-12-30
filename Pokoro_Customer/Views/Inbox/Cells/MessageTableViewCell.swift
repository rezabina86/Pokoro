//
//  MessageTableViewCell.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-30.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "Man")
        view.layer.borderColor = UIColor.PKColors.lightGrey.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 36
        view.clipsToBounds = true
        return view
    }()
    
    private let barcodeTypeLabel: LargeSB = {
        let label = LargeSB()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "My Car's Barcode"
        label.numberOfLines = 1
        return label
    }()
    
    private let dateLabel: SmallSB = {
        let label = SmallSB()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Fri 6 Oct, 09:41"
        label.numberOfLines = 1
        return label
    }()
    
    private let bodyLabel: SmallRegular = {
        let label = SmallRegular()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris"
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
        addSubview(avatarImageView)
        avatarImageView.topAnchor.constraint(equalTo: safeTopAnchor, constant: 12).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -12).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 12).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 72).isActive = true
        
        addSubview(barcodeTypeLabel)
        barcodeTypeLabel.topAnchor.constraint(equalTo: safeTopAnchor, constant: 12).isActive = true
        barcodeTypeLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16).isActive = true
        //barcodeTypeLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: safeTopAnchor, constant: 16).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: barcodeTypeLabel.trailingAnchor, constant: 12).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -12).isActive = true
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        addSubview(bodyLabel)
        bodyLabel.topAnchor.constraint(equalTo: barcodeTypeLabel.bottomAnchor, constant: 4).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -12).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -12).isActive = true
    }

}
