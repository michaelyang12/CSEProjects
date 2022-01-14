//
//  ChatViewController.swift
//  WashU Ticket Share
//
//  Created by lecohen on 11/13/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseAuth
import Firebase

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct DirectMessage: MessageType {
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
}

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {

    //let messagesCollectionView = MessagesCollectionView()
    //set messageroomID into here
    
    var roomID = String()
    var messages = [DirectMessage]()
    var dbMessages = [NSDictionary]()
    var receivingUserID = String()
    var receivingUserName = String()
    var senderID = String()
    var senderName = String()
    
    func currentSender() -> SenderType {
        let currentUser = Auth.auth().currentUser
        let userID = currentUser?.uid ?? "unknown"
        let currentSender = Sender(senderId: userID, displayName: senderName)
        
        return currentSender
    }
    
    func updateMessages() {
        let rootRef = Database.database().reference().child("messageRooms").child(roomID).child("messages")
        rootRef.observe(.value, with: { snapshot in
            var temp = [NSDictionary]()
            var tempMessages = [DirectMessage]()
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! NSDictionary
                    //self.dbMessages.append(dict)
                    let sendUser = Sender(senderId: dict["userSentID"] as? String ?? "null", displayName: dict["userSentName"] as? String ?? "null")
                    temp.append(dict)
                    tempMessages.append(DirectMessage(sender: sendUser, messageId: dict["id"] as? String ?? "unknown", sentDate: Date().addingTimeInterval(-86400), kind: .text(dict["messageText"] as? String ?? "N/A")))
                }
            }
            self.dbMessages = temp
            self.messages = tempMessages
            self.messagesCollectionView.reloadData()
        });
    }
    
    func displayInitialMessages() {
        let date = Date().addingTimeInterval(-86400)
        var tempMessages = [DirectMessage]()
        for msg in dbMessages {
            let sendUser = Sender(senderId: msg["userSentID"] as? String ?? "null", displayName: msg["userSentName"] as? String ?? "null")
            tempMessages.append(DirectMessage(sender: sendUser, messageId: msg["id"] as? String ?? "unknown", sentDate: date, kind: .text(msg["messageText"] as? String ?? "N/A")))
        }
        messages = tempMessages
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        let randomID = UUID().uuidString
        sendMessage(text, randomID)
        self.updateMessages()
        
        //clearing input field
        inputBar.inputTextView.text = ""
        messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)

    }
    
    func sendMessage(_ input: String, _ randomID: String) {
        //upload msg to database
        let date = Date().addingTimeInterval(-86400)
        let rootRef = Database.database().reference()
        let addMessageRef = rootRef.child("messageRooms").child(self.roomID).child("messages")

        let message = [
            "id": randomID,
            "messageText": input,
            "userReceivedID": receivingUserID,
            "userReceivedName": receivingUserName,
            "userSentID": currentSender().senderId,
            "userSentName": currentSender().displayName]

        addMessageRef.child(String(dbMessages.count)).setValue(message)
        messages.append(DirectMessage(sender: currentSender(), messageId: randomID, sentDate: date, kind: .text(input)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
        layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
        self.displayInitialMessages()
        self.updateMessages()
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        print("messages appear")
//        self.updateMessages()
//        self.displayInitialMessages()
//    }
//
    
}
