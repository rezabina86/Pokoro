//
//  PKEmptyStateView.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-08.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class PKEmptyStateView: UIView {
    
    private let titleLabel: LargeSB = {
        let label = LargeSB()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let subTitleLabel: MediumLight = {
        let label = MediumLight()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let emptyImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var image: UIImage? {
        willSet { emptyImageView.image = newValue }
    }
    
    public var title: String? {
        willSet { titleLabel.text = newValue }
    }
    
    public var subtitle: String? {
        willSet { subTitleLabel.text = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: safeCenterYAnchor, constant: 24).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 24).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -24).isActive = true
        
        addSubview(subTitleLabel)
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        subTitleLabel.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 24).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -24).isActive = true
        
        addSubview(emptyImageView)
        emptyImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -16).isActive = true
        emptyImageView.centerXAnchor.constraint(equalTo: safeCenterXAnchor, constant: 0).isActive = true
    }
    
}
