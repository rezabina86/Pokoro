//
//  MessageTableViewCell.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-30.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit
import LetterAvatarKit

class MessageTableViewCell: UITableViewCell {
    
    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.PKColors.lightGrey.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 36
        view.clipsToBounds = true
        return view
    }()
    
    private let nameLabel: LargeSB = {
        let label = LargeSB()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private let barcodeImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "barcodes")?.withTintColor(ThemeManager.shared.theme?.barcodeLabelColor ?? .white)
        return view
    }()
    
    private let barcodeLabel: SmallSB = {
        let label = SmallSB()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = ThemeManager.shared.theme?.barcodeLabelColor
        return label
    }()
    
    private let dateLabel: SmallSB = {
        let label = SmallSB()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private let bodyLabel: MediumRegular = {
        let label = MediumRegular()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let unseenLabel: MediumSB = {
        let view = MediumSB()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.PKColors.green
        view.textAlignment = .center
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    public var thread: ChatThread<ChatMessage>? {
        willSet {
            nameLabel.text = newValue?.userName
            bodyLabel.text = newValue?.lastMessage?.message
            barcodeLabel.text = newValue?.namespaceName
            unseenLabel.isHidden = newValue?.numberOfUnreadMessages == 0
            unseenLabel.text = "\(newValue?.numberOfUnreadMessages ?? 0)"
            dateLabel.text = newValue?.stringDate
            
            let avatarImage = LetterAvatarMaker()
                .setUsername(newValue?.userName ?? "")
                .setLettersFont(UIFont.systemFont(ofSize: 24, weight: .semibold))
                .setBackgroundColors([UIColor.PKColors.green])
                .build()
            
            avatarImageView.image = avatarImage
            barcodeImage.isHidden = !(newValue?.isUserOwnerOfTheNamespace ?? false)
            barcodeLabel.isHidden = !(newValue?.isUserOwnerOfTheNamespace ?? false)
        }
    }

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
        avatarImageView.topAnchor.constraint(equalTo: safeTopAnchor, constant: 16).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -16).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 12).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 72).isActive = true
        
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: safeTopAnchor, constant: 12).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16).isActive = true
        
        addSubview(barcodeImage)
        barcodeImage.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        barcodeImage.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16).isActive = true
        barcodeImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
        barcodeImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        addSubview(barcodeLabel)
        barcodeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        barcodeLabel.leadingAnchor.constraint(equalTo: barcodeImage.trailingAnchor, constant: 8).isActive = true
        
        addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: safeTopAnchor, constant: 16).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 12).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -12).isActive = true
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        addSubview(bodyLabel)
        bodyLabel.topAnchor.constraint(equalTo: barcodeImage.bottomAnchor, constant: 4).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -12).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16).isActive = true
        
        addSubview(unseenLabel)
        unseenLabel.centerYAnchor.constraint(equalTo: bodyLabel.centerYAnchor, constant: 0).isActive = true
        unseenLabel.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -12).isActive = true
        unseenLabel.leadingAnchor.constraint(equalTo: bodyLabel.trailingAnchor, constant: 4).isActive = true
        unseenLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        unseenLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
    }

}
