//
//  ProfileViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-06.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tableFooterView = UIView(frame: CGRect.zero)
        view.separatorInset = ThemeManager.shared.theme!.tableViewSeparatorInset
        view.separatorColor = UIColor.systemGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupViews() {
        view.backgroundColor = ThemeManager.shared.theme?.backgroundColor
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0).isActive = true
    }
    
    private func logOut() {
        PKUserManager.shared.clearDataOnLogout()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.presentAuthenticationCoordinator()
    }
    
    private func askToLogout() {
        let actionController = UIAlertController(title: "logoutMessage".localized, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "logout".localized, style: .destructive) {  [weak self] _ in
            guard let `self` = self else { return }
            self.logOut()
        }
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel)
        actionController.addAction(cancelAction)
        actionController.addAction(logoutAction)
        present(actionController, animated: true)
    }
    
    private func showCompleteProfile() {
        
    }

}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 1:
            showCompleteProfile()
        case 2:
            switch indexPath.row {
            case 0:
                let barcodesController = BarcodesViewController()
                barcodesController.delegate = self
                navigationController?.pushViewController(barcodesController, animated: true)
            case 1:
                let controller = FeedbackViewController()
                present(controller, animated: true)
            case 2:
                askToLogout()
            default:
                break
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 { return 120 }
        if indexPath.section == 3 { return 80 }
        return 52
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 { return 3 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell()
            cell.separatorInset = UIEdgeInsets.init(top: .infinity, left: .infinity, bottom: .infinity, right: .infinity)
            return cell
        case 1:
            let cell = ProfileHeaderTableViewCell()
            cell.separatorInset = UIEdgeInsets.init(top: .infinity, left: .infinity, bottom: .infinity, right: .infinity)
            return cell
        case 2:
            let cell = ProfileActionTableViewCell()
            switch indexPath.row {
            case 0:
                cell.actionImage = UIImage(named: "barcodes")
                cell.title = "myBarcodes".localized
            case 1:
                cell.actionImage = UIImage(named: "feedback")
                cell.title = "feedback".localized
            case 2:
                cell.actionImage = UIImage(named: "logOut")
                cell.title = "logout".localized
            default:
                break
            }
            return cell
        case 3:
            let cell = ProfileVersionTableViewCell()
            cell.separatorInset = UIEdgeInsets(top: .infinity, left: .infinity, bottom: .infinity, right: .infinity)
            return cell
        default:
            fatalError()
        }
    }
    
}

extension ProfileViewController: BarcodesViewControllerDelegate {
    
    func barcodesViewControllerBackButtonDidTapped(_ controller: BarcodesViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
    
}
