//
//  PKNavBarView.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-30.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

class PKNavBarView: UIView {
    
    private var titleLabel: MediumSB = {
        let label = MediumSB()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "logo_white")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var title: String? {
        willSet {
            titleLabel.text = newValue
            logoView.alpha = newValue?.count == 0 ? 1.0 : 0.0
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = ThemeManager.shared.theme?.navBarBackgroundColor
        
        addSubview(logoView)
        logoView.topAnchor.constraint(equalTo: safeTopAnchor, constant: 22).isActive = true
        logoView.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -12).isActive = true
        logoView.centerXAnchor.constraint(equalTo: safeCenterXAnchor, constant: 0).isActive = true
    }

}
