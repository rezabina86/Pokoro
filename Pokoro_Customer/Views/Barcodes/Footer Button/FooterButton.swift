//
//  FooterButton.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-01.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

protocol FooterButtonDelegate: class {
    func footerButtonDidTapped(_ footer: FooterButton, button: PKButton)
}

class FooterButton: UIView {
    
    weak var delegate: FooterButtonDelegate?
    
    private let button: PKButton = {
        let btn = PKButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    public var title: String? {
        willSet { button.setTitle(newValue, for: .normal) }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        button.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
        addSubview(button)
        button.topAnchor.constraint(equalTo: safeTopAnchor, constant: 8).isActive = true
        button.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -8).isActive = true
        button.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 12).isActive = true
        button.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -12).isActive = true
    }
    
    @objc
    private func buttonDidTapped(_ sender: PKButton) {
        delegate?.footerButtonDidTapped(self, button: sender)
    }

}
