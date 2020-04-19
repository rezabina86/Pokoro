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

class MessageViewController: UIViewController {
    
    private let chatBoxView: PKChatTextFieldView = {
        let view = PKChatTextFieldView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.tableFooterView = UIView(frame: CGRect.zero)
        view.keyboardDismissMode = .interactive
        return view
    }()
    
    private var messages: [ChatMessage] = []
    
    var chatManager: PkChatManager<ChatThread<ChatMessage>, ChatMessage>! {
        willSet { navigationItem.title = newValue.selectedThread?.userName }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    override var inputAccessoryView: UIView? {
        return chatBoxView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        
        tableView.re.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -62).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0).isActive = true
        
        chatBoxView.delegate = self
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
        handleKeyboard(shown: true, notification: notification)
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        handleKeyboard(shown: false, notification: notification)
    }
    
    private func handleKeyboard(shown: Bool, notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        guard let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else { return }
        UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions(rawValue: UInt(curve << 16)), animations: {
            if shown && keyboardSize.height > 200 {
                self.tableView.contentOffset.y -= keyboardSize.height
                self.tableView.contentInset.top = keyboardSize.height - 62
            } else if !shown {
                self.tableView.contentInset.top = 0
            }
        }, completion: nil)
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
            cell.transform = CGAffineTransform(rotationAngle: .pi)
            return cell
        } else {
            let cell = OutgoingMessageTableViewCell()
            cell.message = message.message
            cell.date = message.stringDate
            cell.transform = CGAffineTransform(rotationAngle: .pi)
            return cell
        }
    }
    
}
