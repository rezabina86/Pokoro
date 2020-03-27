//
//  RKAlertView.swift
//  Ronaker-Customer
//
//  Created by Reza Bina on 3/30/19.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

class RKAlertView: UIView {
    
    private let holder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private let typeImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: SmallSB = {
        let label = SmallSB()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.PKColors.navy
        return label
    }()
    
    private let messageLabel: SmallRegular = {
        let label = SmallRegular()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.PKColors.navy
        return label
    }()
    
    public var title: String? {
        willSet { titleLabel.text = newValue }
    }
    
    public var message: String? {
        willSet { messageLabel.text = newValue }
    }
    
    public var typeImage: UIImage? {
        willSet { typeImageView.image = newValue }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.applySketchShadow(color: .black, alpha: 0.2, x: 0, y: 2, blur: 4, spread: 0)
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
        backgroundColor = .clear
        
        addSubview(holder)
        holder.topAnchor.constraint(equalTo: safeTopAnchor, constant: 4).isActive = true
        holder.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 8).isActive = true
        holder.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -8).isActive = true
        holder.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -8).isActive = true
        
        holder.addSubview(typeImageView)
        typeImageView.topAnchor.constraint(equalTo: holder.safeTopAnchor, constant: 16).isActive = true
        typeImageView.leadingAnchor.constraint(equalTo: holder.safeLeadingAnchor, constant: 12).isActive = true
        typeImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        typeImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        holder.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 4).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: typeImageView.safeCenterYAnchor, constant: 0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: holder.safeTrailingAnchor, constant: -16).isActive = true
        
        holder.addSubview(messageLabel)
        messageLabel.topAnchor.constraint(equalTo: typeImageView.bottomAnchor, constant: 8).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: holder.safeBottomAnchor, constant: -16).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: holder.safeLeadingAnchor, constant: 16).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: holder.safeTrailingAnchor, constant: -16).isActive = true
    }

}
