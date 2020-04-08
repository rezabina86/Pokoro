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
    
    public var document: NameSpacesBusinessModel.NameSpaceQR? {
        willSet {
            pdfView.document = newValue?.document
            navigationItem.title = newValue?.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupViews() {
        view.backgroundColor = ThemeManager.shared.theme?.backgroundColor
        
        view.addSubview(pdfView)
        pdfView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0).isActive = true
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
        showAlert()
    }
    
    private func showAlert() {
        let exportAction = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let pdfAction = UIAlertAction(title: "Pdf", style: .default) { _ in
            guard let data = self.document?.document?.dataRepresentation() else { return }
            let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        }
        let imageAction = UIAlertAction(title: "Image", style: .default) { _ in
            guard let qr = self.document?.qr, let data = UIImage(ciImage: qr).jpegData(compressionQuality: 1.0) else { return }
            let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        exportAction.addAction(pdfAction)
        exportAction.addAction(imageAction)
        exportAction.addAction(cancelAction)
        present(exportAction, animated: true)
    }

}

extension BarcodeViewerViewController: PKNavBarViewDelegate {
    
    func pkNavBarViewBackButtonDidTapped(_ navBar: PKNavBarView) {
        delegate?.barcodeViewerViewControllerBackButtonDidTapped(self)
    }
    
}
