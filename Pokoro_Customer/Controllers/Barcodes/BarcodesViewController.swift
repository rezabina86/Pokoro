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
    
    private var namespacesLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNamespacesCache()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        syncNamespaces()
    }
    
    private func setupViews() {
        navigationItem.title = "myBarcodes".localized
        view.backgroundColor = ThemeManager.shared.theme?.backgroundColor
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0).isActive = true
    }
    
    private func getNameSpaces() {
        NetworkManager().getNameSpaces(request: NameSpacesBusinessModel.Fetch.Request(page: 1)) { [weak self] (model, error) in
            guard let `self` = self else { return }
            if let error = error {
                self.showAlert(message: error.localized, type: .error)
            } else if let model = model {
                NamespacesCacheManager.shared.namespaces = model.results
                self.namespaces = NameSpacesBusinessModel.Fetch.ViewModel(namespaces: model.results)
            }
        }
    }
    
    private func loadNamespacesCache() {
        guard let namespaces = NamespacesCacheManager.shared.namespaces else { return }
        self.namespaces = NameSpacesBusinessModel.Fetch.ViewModel(namespaces: namespaces)
    }
    
    private func syncNamespaces() {
        guard !namespacesLoaded else { return }
        getNameSpaces()
        namespacesLoaded = true
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
        let controller = BarcodeViewerViewController()
        controller.delegate = self
        controller.document = namespaces?.results[indexPath.row].document
        controller.qrName = namespaces?.results[indexPath.row].name
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = FooterButton()
        view.delegate = self
        view.title = "+ New QR"
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 64
    }
    
}

extension BarcodesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namespaces?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BarcodeTableViewCell()
        cell.name = namespaces?.results[indexPath.row].name
        cell.qr = UIImage(named: "barcodes")
        return cell
    }
    
}

extension BarcodesViewController: BarcodeViewerViewControllerDelegate {
    
    func barcodeViewerViewControllerBackButtonDidTapped(_ controller: BarcodeViewerViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
    
}

extension BarcodesViewController: FooterButtonDelegate {
    
    func footerButtonDidTapped(_ footer: FooterButton, button: PKButton) {
        let alertController = UIAlertController(title: "addQRTitle".localized, message: "addQRMessage".localized, preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "enterName".localized
        }
        let saveAction = UIAlertAction(title: "save".localized, style: UIAlertAction.Style.default, handler: { [weak self] alert -> Void in
            guard let `self` = self else { return }
            let textField = alertController.textFields![0] as UITextField
            self.createNameSpace(textField.text)
        })
        let cancelAction = UIAlertAction(title: "cancel".localized, style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension BarcodesViewController {
    
    private func createNameSpace(_ name: String?) {
        guard let name = name, name.count > 0 else {
            showAlert(message: "createBarcodeError".localized, type: .error)
            return
        }
        NetworkManager().createNamespace(request: CreateNamespaceBusinessModel.Fetch.Request(name: name)) { [weak self] (result, error) in
            guard let `self` = self else { return }
            if let error = error {
                self.showAlert(message: error.localized, type: .error)
            } else if result != nil {
                self.getNameSpaces()
            }
        }
    }
    
}
