//
//  WalkthroughViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-10.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: H2 = {
        let view = H2()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.PKColors.navy
        view.textAlignment = .center
        return view
    }()
    
    private let bodyLabel: LargeRegular = {
        let view = LargeRegular()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.PKColors.ashGrey
        view.textAlignment = .center
        return view
    }()
    
    public var stepImage: UIImage? {
        willSet { imageView.image = newValue }
    }
    
    public var messageTitle: String? {
        willSet { titleLabel.text = newValue }
    }
    
    public var messageBody: String? {
        willSet { bodyLabel.text = newValue }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: view.safeCenterYAnchor, constant: -72).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.safeCenterXAnchor, constant: 0).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 36).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 28).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -28).isActive = true
        
        view.addSubview(bodyLabel)
        bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24).isActive = true
        bodyLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -24).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 28).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -28).isActive = true
    }

}
