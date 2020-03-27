//
//  BarcodesViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-07.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit
import SafariServices

protocol BarcodesViewControllerDelegate: class {
    func barcodesViewControllerBackButtonDidTapped(_ controller: BarcodesViewController)
}

class BarcodesViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let navBar: PKNavBarView = {
        let view = PKNavBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title = "myBarcodes".localized
        return view
    }()
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorInset = ThemeManager.shared.theme!.tableViewSeparatorInset
        view.separatorColor = ThemeManager.shared.theme?.tableViewSeparatorColor
        view.tableFooterView = UIView(frame: CGRect.zero)
        return view
    }()
    
    weak var delegate: BarcodesViewControllerDelegate?
    
    private var namespaces: NameSpacesBusinessModel.Fetch.ViewModel? {
        didSet { tableView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getNameSpaces()
    }
    
    private func setupViews() {
        view.backgroundColor = ThemeManager.shared.theme?.backgroundColor
        
        navBar.delegate = self
        view.addSubview(navBar)
        navBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0).isActive = true
    }
    
    private func getNameSpaces() {
        NetworkManager().getNameSpaces(request: NameSpacesBusinessModel.Fetch.Request(page: 1)) { [weak self] (model, error) in
            guard let `self` = self else { return }
            if let error = error {
                
            } else if let model = model {
                self.namespaces = NameSpacesBusinessModel.Fetch.ViewModel(response: model)
            }
        }
    }

}

extension BarcodesViewController: PKNavBarViewDelegate {
    
    func pkNavBarViewBackButtonDidTapped(_ navBar: PKNavBarView) {
        delegate?.barcodesViewControllerBackButtonDidTapped(self)
    }
    
}

extension BarcodesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let namespace = namespaces?.results[indexPath.row].makeQR() else { return }
        let qrImage = UIImage(ciImage: namespace)
        Logger.log(message: qrImage.size, event: .warning)
        let controller = BarcodeViewerViewController()
        controller.delegate = self
        controller.document = UIImage(named: "qrHolder")?.overlayWith(image: qrImage, posX: 30, posY: 30)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension BarcodesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namespaces?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BarcodeTableViewCell()
        cell.name = namespaces?.results[indexPath.row].name
        if let qr = namespaces?.results[indexPath.row].qr {
            cell.qr = UIImage(ciImage: qr)
        }
        return cell
    }
    
}

extension BarcodesViewController: BarcodeViewerViewControllerDelegate {
    
    func barcodeViewerViewControllerBackButtonDidTapped(_ controller: BarcodeViewerViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
    
}
