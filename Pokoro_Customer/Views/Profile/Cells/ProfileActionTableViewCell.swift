//
//  ProfileActionTableViewCell.swift
//  Ronaker-Customer
//
//  Created by Reza Bina on 27/07/2019.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

class ProfileActionTableViewCell: UITableViewCell {
    
    private let actionImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let titleLabel: LargeLight = {
        let label = LargeLight()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "actionArrow"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    public var actionImage: UIImage? {
        willSet { actionImageView.image = newValue }
    }
    
    public var title: String? {
        willSet { titleLabel.text = newValue }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(actionImageView)
        actionImageView.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 24).isActive = true
        actionImageView.centerYAnchor.constraint(equalTo: safeCenterYAnchor, constant: 0).isActive = true
        actionImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        actionImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: actionImageView.trailingAnchor, constant: 16).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: safeCenterYAnchor, constant: 0).isActive = true
        
        addSubview(arrowImageView)
        arrowImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16).isActive = true
        arrowImageView.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -24).isActive = true
        arrowImageView.centerYAnchor.constraint(equalTo: safeCenterYAnchor, constant: 0).isActive = true
        arrowImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        arrowImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }

}
