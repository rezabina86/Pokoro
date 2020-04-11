//
//  OutgoingMessageTableViewCell.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-06.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class OutgoingMessageTableViewCell: UITableViewCell {
    
    private let chatBubble: PKChatBubble = {
        let view = PKChatBubble()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bubbleColor = UIColor.PKColors.green
        view.titleColor = UIColor.PKColors.navy
        view.dateColor = UIColor.PKColors.navy
        return view
    }()
    
    public var message: String? {
        willSet { chatBubble.text = newValue }
    }
    
    public var date: String? {
        willSet { chatBubble.date = newValue }
    }
    
    private var interaction: UIContextMenuInteraction!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        interaction = UIContextMenuInteraction(delegate: self)
        chatBubble.addInteraction(interaction)
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        
        
        addSubview(chatBubble)
        chatBubble.topAnchor.constraint(equalTo: safeTopAnchor, constant: 6).isActive = true
        chatBubble.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -6).isActive = true
        chatBubble.leadingAnchor.constraint(greaterThanOrEqualTo: safeLeadingAnchor, constant: 72).isActive = true
        chatBubble.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -16).isActive = true
        chatBubble.widthAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
    }

}

extension OutgoingMessageTableViewCell: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (actions) -> UIMenu? in
            let action = UIAction(title: "Copy") { [weak self] _ in
                guard let `self` = self else { return }
                UIPasteboard.general.string = self.message
            }
            return UIMenu(title: "", children: [action])
        }
        return configuration
    }

}
