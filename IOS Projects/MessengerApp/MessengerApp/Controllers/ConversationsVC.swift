//
//  ViewController.swift
//  MessengerApp
//
//  Created by Mohammad Ashraful Islam Sadi on 20/9/20.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ConversationsVC: UIViewController {

    // MARK:- Properties:
    private let spinner = JGProgressHUD(style: .dark)
    private var conversations = [Conversation]()
    
    private let messageList: UITableView = {
       let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    private let noConversationLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversations!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    private var loginObserver: NSObjectProtocol?
    
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(didTapComposeButton))
        view.addSubview(messageList)
        view.addSubview(noConversationLabel)
        setupMessageList()
        fetchMessageList()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        messageList.frame = view.bounds
        noConversationLabel.frame = CGRect(x: 10,
                                           y: (view.height-100)/2,
                                           width: view.width-20,
                                           height: 100)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        validateAuth()
    }
    
    private func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let viewController = LoginVC()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: false)
            
        }
    }
    
    private func setupMessageList(){
        messageList.delegate = self
        messageList.dataSource = self
    }
    
    private func fetchMessageList(){
        messageList.isHidden = false
    }
    
    private func startListeningForConversations(){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        print("DEBUG: Starting conversation fetch....")
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        DatabaseManager.shared.getAllConversations(for: safeEmail) { [weak self] (result) in
            switch result {
            
            case .success(let conversations):
                print("DEBUG: successfully got conversation models")
                guard !conversations.isEmpty else {
                    self?.messageList.isHidden = true
                    self?.noConversationLabel.isHidden = false
                    return
                }
                self?.noConversationLabel.isHidden = false
                self?.messageList.isHidden = false
                self?.conversations = conversations
                
                DispatchQueue.main.async {
                    self?.messageList.reloadData()
                }
                
            case .failure(let error):
                self?.messageList.isHidden = true
                self?.noConversationLabel.isHidden = false
                print("DEBUG: Failed to get conversations: \(error)")
            }
        }
    }
        
    
    //MARK:- Selector Methods:
    
    @objc private func didTapComposeButton(){
        let vc = NewConversationVC()
        let navigationVC = UINavigationController(rootViewController: vc)
        present(navigationVC, animated: true, completion: nil)
    }

}

extension ConversationsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = conversations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.identifier,
                                                 for: indexPath) as! ConversationCell
        cell.configure(withModel: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //let model = conversations[indexPath.row]
        
    }

    // To be completed when building message detail page
    func openConversation(_ model: Conversation){
        let vc = ConversationDetailVC()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    // To be completed later
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //begin delete
            let conversationId = conversations[indexPath.row].id
            tableView.beginUpdates()
            self.conversations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
            //DatabaseManager.shared.
        }
    }
}
