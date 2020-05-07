//
//  PKChatBubble.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-06.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class PKChatBubble: UIView {
    
    private var holder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.zPosition = 3
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let textLabel: LargeRegular = {
        let label = LargeRegular()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeManager.shared.theme?.textColor
        return label
    }()
    
    private let dateLabel: SmallSB = {
        let label = SmallSB()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = ThemeManager.shared.theme?.textColor
        return label
    }()
    
    public var bubbleColor: UIColor? {
        willSet { self.holder.backgroundColor = newValue }
    }
    
    public var text: String? {
        willSet { self.textLabel.text = newValue }
    }
    
    public var date: String? {
        willSet { dateLabel.text = newValue }
    }
    
    public var dateColor: UIColor? {
        willSet { dateLabel.textColor = newValue }
    }
    
    public var titleColor: UIColor? {
        willSet { textLabel.textColor = newValue }
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
        addSubview(holder)
        holder.topAnchor.constraint(equalTo: safeTopAnchor, constant: 0).isActive = true
        holder.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 0).isActive = true
        holder.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: 0).isActive = true
        holder.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: 0).isActive = true
        
        holder.addSubview(self.textLabel)
        textLabel.topAnchor.constraint(equalTo: holder.safeTopAnchor, constant: 12).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: holder.safeLeadingAnchor, constant: 12).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: holder.safeTrailingAnchor, constant: -12).isActive = true
        
        holder.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 2).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: holder.safeBottomAnchor, constant: -6).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: holder.safeLeadingAnchor, constant: 12).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: holder.safeTrailingAnchor, constant: -12).isActive = true
    }

}
