//
//  MessageViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-03.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit
import Combine
import SocketIO

protocol MessageViewControllerDelegate: class {
    func messageViewControllerBackButtonDidTapped(_ controller: MessageViewController)
}

class MessageViewController: UIViewController {
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.tableFooterView = UIView(frame: CGRect.zero)
        view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
        view.keyboardDismissMode = .onDrag
        view.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: view.bounds.size.width - 8.0)
        return view
    }()
    
    private let chatBoxView: PKChatTextFieldView = {
        let view = PKChatTextFieldView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var delegate: MessageViewControllerDelegate?
    private var bottomConst: NSLayoutConstraint!
    
    private var messages: [ChatMessage] = []
    
    var chatManager: PkChatManager<ChatThread<ChatMessage>, ChatMessage>! {
        willSet { navigationItem.title = newValue.selectedThread?.userName }
    }
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        setupViews()
        setupPublishers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deinitializeNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        chatManager.selectThread(nil)
    }
    
    private func setupViews() {
        view.backgroundColor = ThemeManager.shared.theme?.backgroundColor
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0).isActive = true
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
            }, completion: nil)
        }
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.bottomConst.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: { [weak self] in
                guard let `self` = self else { return }
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    private func setupPublishers() {
        chatManager.$messages.sink { [weak self] msg in
            guard let `self` = self else { return }
            let dif = self.messages.difference(from: msg)
            self.messages = msg
            if dif.count == 1 {
                if let index = self.messages.firstIndex(of: dif[0]) {
                    self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                } else { self.tableView.reloadData() }
            } else {
                self.tableView.reloadData()
            }
            if let lastMsg = msg.first {
                self.chatManager.seenMessage(lastMsg)
            }
        }.store(in: &cancellables)
        
        chatManager?.$managerStatus.sink(receiveValue: { [weak self] (event) in
            guard let `self` = self else { return }
            self.handleSocketStatus(event: event)
        }).store(in: &cancellables)
    }
    
    private func handleSocketStatus(event: ManagerStatus) {
        switch event {
        case .connected:
            navigationItem.title = chatManager.selectedThread?.userName
        case .disconnected:
            navigationItem.title = "Connecting..."
        default:
            break
        }
    }

}

extension MessageViewController: PKNavBarViewDelegate {
    func pkNavBarViewBackButtonDidTapped(_ navBar: PKNavBarView) {
        delegate?.messageViewControllerBackButtonDidTapped(self)
    }
}

extension MessageViewController: PKChatTextFieldViewDelegate {
    
    func pkChatTextFieldViewSendButtonDidTapped(_ view: PKChatTextFieldView, with text: String, completion: @escaping () -> Void) {
        guard text != "Text Message" else { return }
        chatManager.sendMessage(text) { [weak self] (success) in
            guard let `self` = self else { return }
            guard success else {
                self.showAlert(message: "nonetworkSend".localized, type: .warning)
                return
            }
            if self.messages.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
            completion()
        }
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
        let message = messages[indexPath.row]
        DispatchQueue(label: "com.pokoro.fetch").async { [weak self] in
            guard let `self` = self else { return }
            if indexPath.row == self.messages.count - 1 {
                self.chatManager.fetchThreadMessages()
            }
        }
        if message.isIncomeMessage {
            let cell = IncomingMessageTableViewCell()
            cell.message = message.message
            cell.date = message.stringDate
            cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            return cell
        } else {
            let cell = OutgoingMessageTableViewCell()
            cell.message = message.message
            cell.date = message.stringDate
            cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            return cell
        }
    }
    
}
