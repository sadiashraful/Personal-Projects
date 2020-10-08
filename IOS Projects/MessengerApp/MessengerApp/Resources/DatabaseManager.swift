//
//  DatabaseManager.swift
//  MessengerApp
//
//  Created by Mohammad Ashraful Islam Sadi on 21/9/20.
//

import Foundation
import FirebaseDatabase
import MessageKit
import CoreLocation

/// Manager object to read and write data to real time firebase database
final class DatabaseManager {
    
    /// Shared instance of class
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

extension DatabaseManager {
    
    /// Returns dictionary node at child path
    public func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void) {
        database.child("\(path)").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
}

// MARK:- Account Management:

extension DatabaseManager {
    
    /// Checks if user exists for given email
    /// Parameters
    /// - `email`: Target email to be checked
    /// - `completion`: Async closure to return with result
    
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    /// Inserts a new user to the database
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void){
        
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
            "email_address": user.emailAddress
        ]) { [weak self] (error, _ ) in
            guard let strongSelf = self else { return }
            guard error == nil else {
                print("DEBUG: Failed to write to database")
                completion(false)
                return
            }
            
            strongSelf.database.child("users").observeSingleEvent(of: .value) { (snapshot) in
                if var usersCollection = snapshot.value as? [[String: String]] {
                    
                    //append to user dictionary
                    let newElement = [
                        "name": user.firstName + " " + user.lastName,
                        "email": user.safeEmail
                    ]
                    usersCollection.append(newElement)
                    strongSelf.database.child("users").setValue(usersCollection) { (error, _ ) in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    }
                }
            }
            
            completion(true)
        }
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
        public var localizedDescription: String {
            switch self {
            case .failedToFetch:
                return "This means blah failed"
            }
        }
    }
}

// MARK:- Sending Messages / Conversations:

extension DatabaseManager {
    
    /// Fetches and returns all conversations for a particular user with a given email
    public func getAllConversations(for email: String,
                                    completion: @escaping (Result<[Conversation], Error>) -> Void){
        
        database.child("\(email)/conversations").observe(.value) { (snapshot) in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let conversations: [Conversation] = value.compactMap { (dictionary) in
                guard let conversationId = dictionary["id"] as? String,
                      let name = dictionary["name"] as? String,
                      let otherUserEmail = dictionary["other_user_email"] as? String,
                      let latestMessage = dictionary["latest_message"] as? [String: Any],
                      let date = latestMessage["date"] as? String,
                      let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["is_read"] as? Bool else {
                        return nil
                }
                
                let latestMessageObject = LatestMessage(date: date,
                                                        text: message,
                                                        isRead: isRead)
                return Conversation(id: conversationId,
                                    name: name,
                                    otherUserEmail: otherUserEmail,
                                    latestMessage: latestMessageObject)
            }
            completion(.success(conversations))
        }
    }
    
    
    /// Gets all messages for a given conversation
//    public func getAllMessagesForConversations(with id: String, completion: @escaping (Result<[Message], Error>) -> Void){
//        database.child("\(id)/messages").observe(.value) { (snapshot) in
//            guard let value = snapshot.value as? [[String: Any]] else {
//                completion(.failure(DatabaseError.failedToFetch))
//                return
//            }
//            
//            let messages: [Message] = value.compactMap { (dictionary) in
//                guard let name = dictionary["name"] as? String,
//                      let _ = dictionary["is_read"] as? Bool,
//                      let messageID = dictionary["id"] as? String,
//                      let content = dictionary["content"] as? String,
//                      let senderEmail = dictionary["sender_email"] as? String,
//                      let type = dictionary["type"] as? String
//                      let dateString = dictionary["date"] as? String
//                //let date = ConversationDetailVC.
//            }
//        }
//    }
}

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}
