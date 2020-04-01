//
//  IncomingMessageTableViewCell.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-06.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class IncomingMessageTableViewCell: UITableViewCell {
    
    private let chatBubble: PKChatBubble = {
        let view = PKChatBubble()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bubbleColor = UIColor.systemGray3
        return view
    }()
    
    public var message: String? {
        willSet { chatBubble.text = newValue }
    }
    
    public var date: String? {
        willSet { chatBubble.date = newValue }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = UIColor.clear
        
        addSubview(chatBubble)
        chatBubble.topAnchor.constraint(equalTo: safeTopAnchor, constant: 6).isActive = true
        chatBubble.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -6).isActive = true
        chatBubble.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 16).isActive = true
        chatBubble.trailingAnchor.constraint(lessThanOrEqualTo: safeTrailingAnchor, constant: -72).isActive = true
        chatBubble.widthAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
    }

}
