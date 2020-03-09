//
//  BarcodeViewerViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-08.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit
import PDFKit

protocol BarcodeViewerViewControllerDelegate: class {
    func barcodeViewerViewControllerBackButtonDidTapped(_ controller: BarcodeViewerViewController)
}

class BarcodeViewerViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let navBar: PKNavBarView = {
        let view = PKNavBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title = " ".localized
        return view
    }()
    
    private let pdfView: PDFView = {
        let view = PDFView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoScales = true
        return view
    }()
    
    weak var delegate: BarcodeViewerViewControllerDelegate?
    public var document: URL? {
        willSet {
            pdfView.document = PDFDocument(url: newValue!)
        }
    }

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
        
        view.addSubview(pdfView)
        pdfView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 0).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: 0).isActive = true
        pdfView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0).isActive = true
    }

}

extension BarcodeViewerViewController: PKNavBarViewDelegate {
    
    func pkNavBarViewBackButtonDidTapped(_ navBar: PKNavBarView) {
        delegate?.barcodeViewerViewControllerBackButtonDidTapped(self)
    }
    
}
