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
        view.title = "Hello"
        return view
    }()
    
    private let pdfView: PDFView = {
        let view = PDFView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.scaleFactor = 0.8
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let exportButton: PKButton = {
        let btn = PKButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("export".localized, for: .normal)
        return btn
    }()
    
    weak var delegate: BarcodeViewerViewControllerDelegate?
    
    public var document: PDFDocument? {
        willSet { pdfView.document = newValue }
    }
    
    public var qrName: String? {
        willSet { navBar.title = newValue }
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
        pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        pdfView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0).isActive = true
        
        exportButton.addTarget(self, action: #selector(exportButtonDidTapped(_:)), for: .touchUpInside)
        view.addSubview(exportButton)
        exportButton.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -16).isActive = true
        exportButton.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 24).isActive = true
        exportButton.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -24).isActive = true
        exportButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc
    private func exportButtonDidTapped(_ sender: PKButton) {
        guard let data = self.document?.dataRepresentation() else { return }
        let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }

}

extension BarcodeViewerViewController: PKNavBarViewDelegate {
    
    func pkNavBarViewBackButtonDidTapped(_ navBar: PKNavBarView) {
        delegate?.barcodeViewerViewControllerBackButtonDidTapped(self)
    }
    
}
