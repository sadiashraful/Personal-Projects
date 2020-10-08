//
//  ConversationDetailVC.swift
//  MessengerApp
//
//  Created by Mohammad Ashraful Islam Sadi on 23/9/20.
//

import UIKit
import MessageKit


class ConversationDetailVC: MessagesViewController {

    private var messages = [Message]()
    
    private let selfSender = Sender(photoURL: "",
                                      senderId: "1",
                                      displayName: "Joe Smith")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(Message(sender: selfSender,
                                 messageId: "1",
                                 sentDate: Date(),
                                 kind: .text("Hello World message")))
        messages.append(Message(sender: selfSender,
                                 messageId: "1",
                                 sentDate: Date(),
                                 kind: .text("Hello World message, Hello World message, Hello World message")))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

    }
}

extension ConversationDetailVC: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
