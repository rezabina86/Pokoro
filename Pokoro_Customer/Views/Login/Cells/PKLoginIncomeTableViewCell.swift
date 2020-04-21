//
//  PKLoginIncomeTableViewCell.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-15.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class PKLoginIncomeTableViewCell: UITableViewCell {

    public let chatBubble: PKLoginChatBubble = {
        let view = PKLoginChatBubble()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bubbleColor = .clear//UIColor.systemGray3
        return view
    }()
    
    public var message: String? {
        willSet { chatBubble.text = newValue }
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
