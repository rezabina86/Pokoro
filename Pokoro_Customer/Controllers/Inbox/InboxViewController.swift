//
//  InboxViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-30.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit
import Combine
import SocketIO

class InboxViewController: UIViewController {
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorInset = ThemeManager.shared.theme!.tableViewSeparatorInset
        view.separatorColor = ThemeManager.shared.theme?.tableViewSeparatorColor
        view.tableFooterView = UIView(frame: CGRect.zero)
        return view
    }()

    private var threads: [ChatThread<ChatMessage>] = [] {
        didSet {
            if threads.count == 0 {
                self.tableView.showEmptyView(title: "No Messages", subtitle: "Scan someone's QR to start a conversation", image: UIImage(named: "talk"))
            } else {
                self.tableView.hideEmptyView()
            }
            tableView.reloadData()
        }
    }
    private var cancellables = Set<AnyCancellable>()
    
    var chatManager: PkChatManager<ChatThread<ChatMessage>, ChatMessage>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCache()
        setupViews()
        setupPublisher()
        PKUserManager.shared.chatManager = chatManager
        
        if !PKUserManager.shared.isWalkthroughShown {
            present(WalkthroughPageViewController(), animated: true)
            PKUserManager.shared.isWalkthroughShown = true
        }
        
    }
    
    private func setupViews() {
        view.backgroundColor = ThemeManager.shared.theme?.backgroundColor
        navigationItem.title = "Messages"
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0).isActive = true
    }
    
    private func loadCache() {
        let savedThreads = ThreadsCacheManager.shared.threads.map({ ChatThread<ChatMessage>(apiResponse: $0) })
        let newOrder = savedThreads.sorted(by: { $0.lastMessageDate > $1.lastMessageDate })
        threads = newOrder
    }
    
    private func setupPublisher() {
        chatManager.$threads.sink { [weak self] (thrds) in
            guard let `self` = self else { return }
            if thrds.count > 0 { self.threads = thrds }
        }.store(in: &cancellables)
        
        chatManager.$managerStatus.sink { [weak self] (status) in
            guard let `self` = self else { return }
            self.handleSocketStatus(event: status)
        }.store(in: &cancellables)
    }
    
    private func handleSocketStatus(event: ManagerStatus) {
        switch event {
        case .connected:
            navigationItem.title = "Messages"
        case .disconnected:
            navigationItem.title = "Connecting..."
        default:
            break
        }
    }
    
}

extension InboxViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        chatManager.selectThread(threads[indexPath.row])
        let messageController = MessageViewController()
        messageController.delegate = self
        messageController.chatManager = chatManager
        messageController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(messageController, animated: true)
    }
    
}

extension InboxViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageTableViewCell()
        cell.thread = threads[indexPath.row]
        return cell
    }
    
}

extension InboxViewController: MessageViewControllerDelegate {
    
    func messageViewControllerBackButtonDidTapped(_ controller: MessageViewController) {
        controller.navigationController?.popViewController(animated: true)
        chatManager?.selectThread(nil)
    }
    
}
