//
//  MessageViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-03.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

protocol MessageViewControllerDelegate: class {
    func messageViewControllerBackButtonDidTapped(_ controller: MessageViewController)
}

class MessageViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let navBar: PKNavBarView = {
        let view = PKNavBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title = "David"
        return view
    }()
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.tableFooterView = UIView(frame: CGRect.zero)
        return view
    }()
    
    private let chatBoxView: PKChatTextFieldView = {
        let view = PKChatTextFieldView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var delegate: MessageViewControllerDelegate?
    private var bottomConst: NSLayoutConstraint!
    private var messages: [String] = []
    
    public var thread: DemoMessagesBusinessModel.Thread? {
        didSet {
            messages = thread?.messages.map({ $0.message }) ?? []
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deinitializeNotification()
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
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: { self.view.layoutIfNeeded() }, completion: nil)
        }
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.bottomConst.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: { self.view.layoutIfNeeded() }, completion: nil)
        }
    }

}

extension MessageViewController: PKNavBarViewDelegate {
    func pkNavBarViewBackButtonDidTapped(_ navBar: PKNavBarView) {
        delegate?.messageViewControllerBackButtonDidTapped(self)
    }
}

extension MessageViewController: PKChatTextFieldViewDelegate {
    
    func pkChatTextFieldViewSendButtonDidTapped(_ view: PKChatTextFieldView, with text: String) {
        messages.append(text)
        tableView.insertRows(at: [IndexPath(row: messages.count - 1, section: 0)], with: .bottom)
        tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
        
        DemoMessageManager.shared.saveMessage(thread!.id, message: text)
    }
    
}

extension MessageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension MessageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OutgoingMessageTableViewCell()
        cell.message = messages[indexPath.row]
        return cell
    }
    
}
