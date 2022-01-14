//
//  MyMessagesViewController.swift
//  WashU Ticket Share
//
//  Created by lecohen on 11/13/21.
//

import UIKit
import Firebase
import FirebaseAuth

class MyMessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var messageCell: UITableViewCell!
    
    var messageRooms: [MessageRoom] = []
    var sentFromDetailedTicket: Bool = false
    var detailedRoomID: String?
    
    func updateMessageList() {
        guard let currentUser = FirebaseAuth.Auth.auth().currentUser else {
            return
        }
        let userID = currentUser.uid
        let rootRef = Database.database().reference()
        rootRef.child("messageRooms").observe(.value, with: { [self] snapshot in
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                for child in snapshot.children { //even though there is only 1 child
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String: AnyObject]
                    let user1id = dict["user1id"] as? String ?? "null"
                    let user2id = dict["user2id"] as? String ?? "null"
                    
                    if (user1id == userID || user2id == userID) { //only display messages with current user
                        var exists = false
                        for room in self.messageRooms {
                            if room.id == MessageRoom(snapshot: snap).id {
                                exists = true
                                break
                            }
                        }
                        if (!exists) {
                            self.messageRooms.append(MessageRoom(snapshot: snap))
                        }
                    }
                }
                self.table.reloadData()
            }
            
            if (sentFromDetailedTicket) {
                if (messageRooms.count > 1) {
                    let endRange = messageRooms.count - 1
                    for i in 0...endRange {
                        if (messageRooms[i].id == (self.detailedRoomID ?? "null")) {
                            let currentUser = FirebaseAuth.Auth.auth().currentUser
                            let vc = ChatViewController()
                            self.updateMessageList()
                            vc.roomID = messageRooms[i].id
                            vc.dbMessages = messageRooms[i].messages
                            if (messageRooms[i].user1id != currentUser?.uid) {
                                vc.title = messageRooms[i].user1name
                                vc.receivingUserName = messageRooms[i].user1name
                                vc.receivingUserID = messageRooms[i].user1id
                                vc.senderID = messageRooms[i].user2id
                                vc.senderName = messageRooms[i].user2name
                            }
                            else if (messageRooms[i].user2id != currentUser?.uid) {
                                vc.title = messageRooms[i].user2name
                                vc.receivingUserName = messageRooms[i].user2name
                                vc.receivingUserID = messageRooms[i].user2id
                                vc.senderID = messageRooms[i].user1id
                                vc.senderName = messageRooms[i].user1name
                            }
                            else {
                                vc.title = "Nothing Here!"
                                vc.receivingUserName = "unknown"
                                vc.receivingUserID = "unknown"
                            }
                            self.sentFromDetailedTicket = false
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                else {
                    let currentUser = FirebaseAuth.Auth.auth().currentUser
                    let vc = ChatViewController()
                    self.updateMessageList()
                    vc.roomID = messageRooms[0].id
                    vc.dbMessages = messageRooms[0].messages
                    if (messageRooms[0].user1id != currentUser?.uid) {
                        vc.title = messageRooms[0].user1name
                        vc.receivingUserName = messageRooms[0].user1name
                        vc.receivingUserID = messageRooms[0].user1id
                        vc.senderID = messageRooms[0].user2id
                        vc.senderName = messageRooms[0].user2name
                    }
                    else if (messageRooms[0].user2id != currentUser?.uid) {
                        vc.title = messageRooms[0].user2name
                        vc.receivingUserName = messageRooms[0].user2name
                        vc.receivingUserID = messageRooms[0].user2id
                        vc.senderID = messageRooms[0].user1id
                        vc.senderName = messageRooms[0].user1name
                    }
                    else {
                        vc.title = "Nothing Here!"
                        vc.receivingUserName = "unknown"
                        vc.receivingUserID = "unknown"
                    }
                    self.sentFromDetailedTicket = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            self.table.reloadData()
        });
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageRooms.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentUser = Auth.auth().currentUser
        let cell = table.dequeueReusableCell(withIdentifier: "messageRoom", for: indexPath) as! MessagesTableViewCell

        if (messageRooms[indexPath.row].user1id != currentUser?.uid) {
            cell.sellerName.text = messageRooms[indexPath.row].user1name
        }
        else if (messageRooms[indexPath.row].user2id != currentUser?.uid) {
            cell.sellerName.text = messageRooms[indexPath.row].user2name
        }
        else {
            cell.sellerName.text = "Nothing Here!"
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentUser = FirebaseAuth.Auth.auth().currentUser
        let vc = ChatViewController()
        self.updateMessageList()
        vc.roomID = messageRooms[indexPath.row].id
        vc.dbMessages = messageRooms[indexPath.row].messages
        if (messageRooms[indexPath.row].user1id != currentUser?.uid) {
            vc.title = messageRooms[indexPath.row].user1name
            vc.receivingUserName = messageRooms[indexPath.row].user1name
            vc.receivingUserID = messageRooms[indexPath.row].user1id
            vc.senderID = messageRooms[indexPath.row].user2id
            vc.senderName = messageRooms[indexPath.row].user2name
        }
        else if (messageRooms[indexPath.row].user2id != currentUser?.uid) {
            vc.title = messageRooms[indexPath.row].user2name
            vc.receivingUserName = messageRooms[indexPath.row].user2name
            vc.receivingUserID = messageRooms[indexPath.row].user2id
            vc.senderID = messageRooms[indexPath.row].user1id
            vc.senderName = messageRooms[indexPath.row].user1name
        }
        else {
            vc.title = "Nothing Here!"
            vc.receivingUserName = "unknown"
            vc.receivingUserID = "unknown"
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        self.updateMessageList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateMessageList()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
