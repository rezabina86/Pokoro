//
//  PKNavBarView.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-30.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

protocol PKNavBarViewDelegate: class {
    func pkNavBarViewBackButtonDidTapped(_ navBar: PKNavBarView)
}

class PKNavBarView: UIView {
    
    private let titleLabel: H2 = {
        let label = H2()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "logo_white")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray3
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ArrowRight"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public var title: String? {
        willSet {
            titleLabel.text = newValue
            logoView.alpha = newValue?.count == 0 ? 1.0 : 0.0
        }
    }
    
    public var isBackButtonHidden: Bool = false {
        willSet { backButton.isHidden = newValue }
    }
    
    weak var delegate: PKNavBarViewDelegate?

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
        
        addSubview(separator)
        separator.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: 0).isActive = true
        separator.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 0).isActive = true
        separator.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: 0).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(logoView)
        logoView.topAnchor.constraint(equalTo: safeTopAnchor, constant: 18).isActive = true
        logoView.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -14).isActive = true
        logoView.centerXAnchor.constraint(equalTo: safeCenterXAnchor, constant: 0).isActive = true
        
        addSubview(titleLabel)
        titleLabel.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -14).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: safeCenterXAnchor, constant: 0).isActive = true
        
        backButton.addTarget(self, action: #selector(backButtonDidTapped(_:)), for: .touchUpInside)
        addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 8).isActive = true
        backButton.bottomAnchor.constraint(equalTo: separator.safeTopAnchor, constant: 0).isActive = true
        //backButton.topAnchor.constraint(equalTo: safeTopAnchor, constant: 0).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 46).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    @objc
    private func backButtonDidTapped(_ sender: UIButton) {
        delegate?.pkNavBarViewBackButtonDidTapped(self)
    }

}
