//
//  BarcodeTableViewCell.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-07.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class BarcodeTableViewCell: UITableViewCell {
    
    private let barcodeImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "barcodeDemo")
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    private let barcodeName: LargeRegular = {
        let label = LargeRegular()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public var name: String? {
        willSet { barcodeName.text = newValue }
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
        addSubview(barcodeImageView)
        barcodeImageView.topAnchor.constraint(equalTo: safeTopAnchor, constant: 12).isActive = true
        barcodeImageView.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -12).isActive = true
        barcodeImageView.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 12).isActive = true
        barcodeImageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        barcodeImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        addSubview(barcodeName)
        barcodeName.leadingAnchor.constraint(equalTo: barcodeImageView.trailingAnchor, constant: 12).isActive = true
        barcodeName.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -12).isActive = true
        barcodeName.centerYAnchor.constraint(equalTo: barcodeImageView.safeCenterYAnchor).isActive = true
    }

}
