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
        view.autoScales = true
        view.backgroundColor = .lightGray
        return view
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(exportButtonDidTapped(_:)))
        
        view.addSubview(pdfView)
        pdfView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        pdfView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0).isActive = true
    }
    
    @objc
    private func exportButtonDidTapped(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
    private func showAlert() {
        let exportAction = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let pdfAction = UIAlertAction(title: "Export as pdf", style: .default) { _ in
            guard let data = self.document?.document?.dataRepresentation() else { return }
            let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            self.present(activityController, animated: true)
        }
        let imageAction = UIAlertAction(title: "Export as image", style: .default) { _ in
            guard let qr = self.document?.qr, let data = UIImage(ciImage: qr).jpegData(compressionQuality: 1.0) else { return }
            let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            self.present(activityController, animated: true)
        }
        let codeAction = UIAlertAction(title: "Export as code", style: .default) { _ in
            guard let code = self.document?.id else { return }
            let stringCode = "http://pokoro.app/code/\(code)"
            let activityController = UIActivityViewController(activityItems: [stringCode], applicationActivities: nil)
            self.present(activityController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        exportAction.addAction(pdfAction)
        exportAction.addAction(imageAction)
        exportAction.addAction(codeAction)
        exportAction.addAction(cancelAction)
        present(exportAction, animated: true)
    }

}

extension BarcodeViewerViewController: PKNavBarViewDelegate {
    
    func pkNavBarViewBackButtonDidTapped(_ navBar: PKNavBarView) {
        delegate?.barcodeViewerViewControllerBackButtonDidTapped(self)
    }
    
}
