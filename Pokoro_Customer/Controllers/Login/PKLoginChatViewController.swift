//
//  PKLoginChatViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-15.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit
import Combine

protocol PKLoginChatViewControllerDelegate: class {
    func pkLoginChatViewControllerUserIsAuthenticated(_ controller: PKLoginChatViewController)
    func pkLoginChatViewControllerCloseButtonDidTap(_ controller: PKLoginChatViewController)
}

class PKLoginChatViewController: UIViewController {
    
    public var authenticationModel: AuthenticationModel!
    
    private var navBar: UINavigationBar = {
        let view = UINavigationBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.tableFooterView = UIView(frame: CGRect.zero)
        view.backgroundColor = .white
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    private let chatBoxView: PKLoginTextFieldView = {
        let view = PKLoginTextFieldView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var delegate: PKLoginChatViewControllerDelegate?
    private var bottomConst: NSLayoutConstraint!
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupListeners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chatBoxView.textField.becomeFirstResponder()
        authenticationModel.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deinitializeNotification()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        let navItem = UINavigationItem(title: "")
        let navBarButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonDidTap(_:)))
        navItem.leftBarButtonItem = navBarButton
        navBar.items = [navItem]
        view.addSubview(navBar)
        navBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0).isActive = true
        
        chatBoxView.delegate = self
        view.addSubview(chatBoxView)
        chatBoxView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0).isActive = true
        bottomConst = chatBoxView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        bottomConst.isActive = true
        chatBoxView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0).isActive = true
        chatBoxView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0).isActive = true
    }
    
    func initializeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deinitializeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConst.constant = -keyboardSize.height
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseInOut], animations: { [weak self] in
                guard let `self` = self else { return }
                self.view.layoutIfNeeded()
                if self.authenticationModel.messages.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: self.authenticationModel.messages.count - 1, section: 0), at: .bottom, animated: true)
                }
            }, completion: nil)
        }
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.bottomConst.constant = 0
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseInOut], animations: { [weak self] in
                guard let `self` = self else { return }
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    private func setupListeners() {
        authenticationModel.$isTextFieldSecure.sink { (isSecure) in
            self.chatBoxView.textField.isSecureTextEntry = isSecure
        }.store(in: &cancellables)
        
        authenticationModel.$lastMessage.sink { (msg) in
            if msg != nil {
                self.tableView.insertRows(at: [IndexPath(row: self.authenticationModel.messages.count - 1, section: 0)], with: .fade)
                self.tableView.scrollToRow(at: IndexPath(row: self.authenticationModel.messages.count - 1, section: 0), at: .bottom, animated: true)
            }
        }.store(in: &cancellables)
        
        authenticationModel.$isUserAuthenticated.sink { [weak self] (isAuthenticated) in
            guard let self = self else { return }
            if isAuthenticated {
                self.delegate?.pkLoginChatViewControllerUserIsAuthenticated(self)
            }
        }.store(in: &cancellables)
    }
    
    @objc
    private func closeButtonDidTap(_ sender: UIBarButtonItem) {
        delegate?.pkLoginChatViewControllerCloseButtonDidTap(self)
    }

}

extension PKLoginChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension PKLoginChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authenticationModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = authenticationModel.messages[indexPath.row]
        if msg.isUserInput {
            let cell = PKLoginOutgoTableViewCell()
            cell.message = msg.isSecure ? "*******" : msg.message
            return cell
        } else {
            let cell = PKLoginIncomeTableViewCell()
            cell.message = msg.message
            return cell
        }
    }
    
}

extension PKLoginChatViewController: PKLoginTextFieldViewDelegate {
    
    func pkLoginTextFieldSendButtonDidTap(_ view: PKLoginTextFieldView, with text: String) {
        authenticationModel.saveUserInput(text)
    }
    
}
