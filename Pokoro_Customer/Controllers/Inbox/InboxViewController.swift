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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let navBar: PKNavBarView = {
        let view = PKNavBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isBackButtonHidden = true
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
    
    public var chatData: ChatsDataModel?
    private var threads: [ChatsDataModel.Thread] = [] {
        didSet {
            if threads.count == 0 {
                self.tableView.showEmptyView(title: "No Messages", subtitle: "Scan Barcode to start a conversation", image: UIImage(named: "talk"))
            } else {
                self.tableView.hideEmptyView()
            }
            tableView.reloadData()
        }
    }
    private var cancellables = Set<AnyCancellable>()
    
    private var chatManager: PkChatManager<ChatThread<ChatMessage>, ChatMessage>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatManager = PkChatManager()
        
        
        
        loadCache()
        setupViews()
        setupPublisher()
        PKUserManager.shared.chatManager = chatManager
    }
    
    private func setupViews() {
        view.backgroundColor = ThemeManager.shared.theme?.backgroundColor
        
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
    
    private func loadCache() {
        let savedThreads = ThreadsCacheManager.shared.threads.map({ ChatsDataModel.Thread(apiResponse: $0) })
        let newOrder = savedThreads.sorted(by: { $0.lastMessageDate > $1.lastMessageDate })
        threads = newOrder
    }
    
    private func setupPublisher() {
        chatData?.$socketStatus.sink(receiveValue: { [weak self] (event) in
            guard let `self` = self else { return }
            self.handleSocketStatus(event: event)
        }).store(in: &cancellables)
        
        //*****
        chatData?.$threads.sink(receiveValue: { [weak self] (threads) in
            guard let `self` = self else { return }
            if threads.count > 0 { self.threads = threads }
        }).store(in: &cancellables)
        
        //*****
        PKUserManager.shared.$isAppInForeground.sink { [weak self] (value) in
            guard let `self` = self else { return }
            value ? self.chatData?.connect() : self.chatData?.disconnect()
        }.store(in: &cancellables)
        
        //*****
        
    }
    
    private func handleSocketStatus(event: SocketClientEvent) {
        switch event {
        case .connect:
            navBar.title = "Updating..."
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let `self` = self else { return }
                self.getThreads()
                
            }
        case .disconnect:
            if PKUserManager.shared.isAppInForeground, PKUserManager.shared.isUserLoggedIn { chatData?.connect() }
        case .reconnect:
            navBar.title = "Connecting..."
        default:
            break
        }
    }
    
    private func getThreads() {
        NetworkManager().getChats { [weak self] (chats, error) in
            guard let `self` = self else { return }
            self.navBar.title = ""
            if let error = error {
                Logger.log(message: error, event: .error)
            } else if let chats = chats {
                self.chatData?.setup(apiResponse: chats)
                ThreadsCacheManager.shared.threads = chats.results
                PKUserManager.shared.chatDataModel = self.chatData
            }
        }
    }
    
}

extension InboxViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        chatData?.select(thread: threads[indexPath.row])
        let messageController = MessageViewController()
        messageController.delegate = self
        messageController.chatData = chatData
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
        chatData?.select(thread: nil)
    }
    
}
