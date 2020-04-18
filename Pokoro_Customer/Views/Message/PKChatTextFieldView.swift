//
//  PKChatTextFieldView.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-06.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

protocol PKChatTextFieldViewDelegate: class {
    func pkChatTextFieldViewSendButtonDidTapped(_ view: PKChatTextFieldView, with text: String, completion: @escaping () -> Void)
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
    
    public let textField: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        view.font = UIFont.systemFont(ofSize: 16)
        view.text = "textMessage".localized
        view.textColor = UIColor.lightGray
        return view
    }()
    
    private var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "sendButton"), for: .normal)
        return button
    }()
    
    weak var delegate: PKChatTextFieldViewDelegate?
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize.init(width: size.width, height: 56)
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
        backgroundColor = ThemeManager.shared.theme?.backgroundColor
        
        addSubview(separator)
        separator.topAnchor.constraint(equalTo: safeTopAnchor, constant: 0).isActive = true
        separator.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 0).isActive = true
        separator.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: 0).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(holder)
        holder.topAnchor.constraint(equalTo: safeTopAnchor, constant: 12).isActive = true
        holder.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -12).isActive = true
        holder.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 16).isActive = true
        holder.heightAnchor.constraint(greaterThanOrEqualToConstant: 32).isActive = true
        
        textField.delegate = self
        holder.addSubview(textField)
        textField.topAnchor.constraint(equalTo: holder.safeTopAnchor, constant: 1).isActive = true
        textField.bottomAnchor.constraint(equalTo: holder.safeBottomAnchor, constant: -1).isActive = true
        textField.leadingAnchor.constraint(equalTo: holder.safeLeadingAnchor, constant: 12).isActive = true
        textField.trailingAnchor.constraint(equalTo: holder.safeTrailingAnchor, constant: -12).isActive = true
        
        sendButton.addTarget(self, action: #selector(sendButtonDidTapped(_:)), for: .touchUpInside)
        addSubview(sendButton)
        sendButton.bottomAnchor.constraint(equalTo: holder.bottomAnchor, constant: 0).isActive = true
        sendButton.leadingAnchor.constraint(equalTo: holder.safeTrailingAnchor, constant: 4).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -16).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    @objc
    private func sendButtonDidTapped(_ sender: UIButton) {
        guard let text = textField.text, text.count != 0 else { return }
        delegate?.pkChatTextFieldViewSendButtonDidTapped(self, with: text, completion: { [weak self] in
            guard let `self` = self else { return }
            self.textField.text = nil
            self.textField.sizeToFit()
        })
    }

}

extension PKChatTextFieldView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.sizeToFit()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "textMessage".localized
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = ThemeManager.shared.theme?.textColor
        }
    }
    
    
    
}
