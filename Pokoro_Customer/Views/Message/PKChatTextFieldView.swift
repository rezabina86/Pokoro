//
//  PKChatTextFieldView.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-06.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

protocol PKChatTextFieldViewDelegate: class {
    func pkChatTextFieldViewSendButtonDidTapped(_ view: PKChatTextFieldView, with text: String?)
}

class PKChatTextFieldView: UIView {
    
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray3
        return view
    }()
    
    private let holder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.backgroundColor = ThemeManager.shared.theme?.backgroundColor
        view.layer.borderColor = UIColor.systemGray3.cgColor
        return view
    }()
    
    private let textField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.placeholder = "textMessage".localized
        view.borderStyle = .none
        return view
    }()
    
    private var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "sendButton"), for: .normal)
        return button
    }()
    
    weak var delegate: PKChatTextFieldViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(separator)
        separator.topAnchor.constraint(equalTo: safeTopAnchor, constant: 0).isActive = true
        separator.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 0).isActive = true
        separator.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: 0).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(holder)
        holder.topAnchor.constraint(equalTo: safeTopAnchor, constant: 12).isActive = true
        holder.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -12).isActive = true
        holder.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 16).isActive = true
        holder.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        holder.addSubview(textField)
        textField.topAnchor.constraint(equalTo: holder.safeTopAnchor, constant: 3).isActive = true
        textField.bottomAnchor.constraint(equalTo: holder.safeBottomAnchor, constant: -3).isActive = true
        textField.leadingAnchor.constraint(equalTo: holder.safeLeadingAnchor, constant: 16).isActive = true
        textField.trailingAnchor.constraint(equalTo: holder.safeTrailingAnchor, constant: -16).isActive = true
        
        sendButton.addTarget(self, action: #selector(sendButtonDidTapped(_:)), for: .touchUpInside)
        addSubview(sendButton)
        sendButton.centerYAnchor.constraint(equalTo: holder.safeCenterYAnchor).isActive = true
        sendButton.leadingAnchor.constraint(equalTo: holder.safeTrailingAnchor, constant: 4).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -16).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    @objc
    private func sendButtonDidTapped(_ sender: UIButton) {
        guard let text = textField.text, text.count != 0 else { return }
        delegate?.pkChatTextFieldViewSendButtonDidTapped(self, with: text)
    }

}
