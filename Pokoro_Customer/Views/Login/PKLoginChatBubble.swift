//
//  PKLoginChatBubble.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-15.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class PKLoginChatBubble: UIView {

    private var holder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.zPosition = 3
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeManager.shared.theme?.textColor
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    public var bubbleColor: UIColor? {
        willSet { self.holder.backgroundColor = newValue }
    }
    
    public var text: String? {
        willSet { self.textLabel.text = newValue }
    }
    
    public var titleColor: UIColor? {
        willSet { textLabel.textColor = newValue }
    }
    
    public var borderWidth: CGFloat? {
        willSet { holder.layer.borderWidth = newValue ?? 1.0 }
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
        textLabel.bottomAnchor.constraint(equalTo: holder.safeBottomAnchor, constant: -12).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: holder.safeLeadingAnchor, constant: 12).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: holder.safeTrailingAnchor, constant: -12).isActive = true
    }

}
