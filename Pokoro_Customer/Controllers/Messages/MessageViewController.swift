//
//  MessageViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-03.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

protocol MessageViewControllerDelegate: class {
    func messageViewControllerBackButtonDidTapped(_ controller: MessageViewController)
}

class MessageViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let navBar: PKNavBarView = {
        let view = PKNavBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title = "David"
        return view
    }()
    
    weak var delegate: MessageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = ThemeManager.shared.theme?.backgroundColor
        
        navBar.delegate = self
        view.addSubview(navBar)
        navBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0).isActive = true
    }

}

extension MessageViewController: PKNavBarViewDelegate {
    func pkNavBarViewBackButtonDidTapped(_ navBar: PKNavBarView) {
        delegate?.messageViewControllerBackButtonDidTapped(self)
    }
}
