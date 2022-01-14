//
//  DetailedTicketViewController.swift
//  WashU Ticket Share
//
//  Created by Michael Yang on 12/2/21.
//

import UIKit
import Firebase
import FirebaseAuthUI

class DetailedTicketViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return interestedname.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       let row = interestedname[row]
       return row
    }
    
    var id: String?
    var nameOfEvent: String?
    var dateOf: String?
    var price: String?
    var sellerName: String?
    var interestedname:[String] = []
    var interestedid:[String] = []
    
    let UIPicker: UIPickerView = UIPickerView()
    var sellerID: String?
    var buyerName: String?
    var buyerID: String?
    
    @IBOutlet weak var messageSellerButton: UIButton!

    @objc func buttonAction(_sender:UIButton!) {
        
        let rootRef = Database.database().reference()
        
        guard let id = id else{
            return
        }

        guard let buyerID = buyerID else{
            return
        }
        if !interestedid.contains(buyerID) {
            interestedid.append(buyerID)
            rootRef.child("tickets").child(id).child("interestedid").setValue(interestedid)
        }
        guard let buyerName = buyerName else {
            return
        }
        if !interestedname.contains(buyerName) {
            interestedname.append(buyerName)
            rootRef.child("tickets").child(id).child("interestedname").setValue(interestedname)
        }
        
        rootRef.child("messageRooms").getData(completion:  { error, snapshot in
            guard let currentUser = FirebaseAuth.Auth.auth().currentUser else {
                return
            }

            let userID = currentUser.uid
            let roomid = (self.sellerID ?? "unknown") + userID
            var roomExists = false
            //var messages = [NSDictionary]()
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let dict = snap.value as! [String: AnyObject]
                let id = dict["id"]
                //messages = dict["messages"] as! [NSDictionary]
                let user1id = dict["user1id"] as? String ?? "unknown"
                let user2id = dict["user2id"] as? String ?? "unknown"
                //if room already exists, go to that room
                if ((id as? String ?? "unknown" == roomid)
                        || ((user1id == self.sellerID) && (user2id == userID))
                        || ((user2id == self.sellerID) && (user1id == userID)))
                {
                    roomExists = true
                    break
                }
            }
            if (roomExists) {
                let navVC = self.tabBarController?.viewControllers![1] as! UINavigationController
                let msgVC = navVC.topViewController as! MyMessagesViewController

                msgVC.detailedRoomID = roomid
                msgVC.sentFromDetailedTicket = true
                self.tabBarController?.selectedIndex = 1
                
            } else {
//                rootRef.child("users/\(userID)/name").getData(completion:  { error, snapshot in
//                    guard error == nil else {
//                        print(error!.localizedDescription)
//                        return
//                    }
//                    let buyerName = snapshot.value as? String ?? "Unknown"
                    let addRef = Database.database().reference().child("messageRooms")
                    
                    let message: NSDictionary = [
                        "messageText": "Beginning direct message with: \(self.sellerName ?? "nullEvent")",
                        "roomID": roomid,
                        "userReceivedID": self.sellerID ?? "unknown",
                        "userReceivedName": self.sellerName ?? "unknown",
                        "userSentID": userID,
                        "userSentName": buyerName]

                    addRef.child(roomid).setValue([
                        "id":roomid,
                        "user1id": self.sellerID ?? "unknown",
                        "user1name": self.sellerName ?? "unknown",
                        "user2id": userID,
                        "user2name": buyerName,
                        "messages": [message],
                    ])
                    
                    //go into chatVC
                    let chatVC = ChatViewController()
                    
                    chatVC.title = self.sellerName ?? "unknown"
                    chatVC.roomID = roomid
                    chatVC.receivingUserID = self.sellerID ?? "unknown"
                    chatVC.receivingUserName = self.sellerName ?? "unknown"
                    chatVC.senderID = userID
                    chatVC.senderName = buyerName
                    chatVC.dbMessages = []
                    self.navigationController?.pushViewController(chatVC, animated: true)
//                });
            }
        });
    }
    
    @objc func confirm(_sender:UIButton!) {
        if (interestedname.count == 0) {
            return
        }
        let buyerName = interestedname[UIPicker.selectedRow(inComponent: 0)]
        // delete ticket
        let buyerID = interestedid[UIPicker.selectedRow(inComponent: 0)]
        let rootRef = Database.database().reference()
        
        guard let id = id else{
            return
        }
        
        guard let currentUser = FirebaseAuth.Auth.auth().currentUser else {
            return
        }
        let sellerID = currentUser.uid
        
        guard let sellerName = sellerName else {
            return
        }
        guard let nameOfEvent = nameOfEvent else {
            return
        }
        guard let dateOf = dateOf else {
            return
        }
        guard let price = price else {
            return
        }
        
        
        rootRef.child("inbox").childByAutoId().setValue(["buyerName": buyerName, "buyerID": buyerID, "sellerName":sellerName, "sellerID": sellerID, "event name":nameOfEvent, "event date": dateOf, "price": price, "completed": false])
        
        //delete ticket
        rootRef.child("tickets").child(id).updateChildValues(["sold":true])
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        guard let currentUser = FirebaseAuth.Auth.auth().currentUser else {
            return
        }
        let rootRef = Database.database().reference()
        guard let id = id else {
            return
        }
        rootRef.child("tickets").child(id).child("interestedname").observe(.value, with: { snapshot in
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                let snap = snapshot
                self.interestedname = snap.value as! [String]
                self.UIPicker.reloadAllComponents()
            }
        })
        rootRef.child("tickets").child(id).child("interestedid").observe(.value, with: { snapshot in
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                let snap = snapshot
                self.interestedid = snap.value as! [String]
            }
        })
        
        if(currentUser.uid != sellerID) {
            let theFrame = CGRect(x: view.frame.midX-150, y: view.frame.midY+100, width: 300, height: 60)
            let button = UIButton(frame: theFrame)
            button.backgroundColor = UIColor.systemGreen
            button.setTitle("Message \(sellerName ?? "Seller")", for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

            view.addSubview(button)
        } else {
            // show list of interested users
            
            UIPicker.delegate = self as UIPickerViewDelegate
            UIPicker.dataSource = self as UIPickerViewDataSource
            self.view.addSubview(UIPicker)
            UIPicker.center = self.view.center
            UIPicker.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 100)
            
            let buttonFrame = CGRect(x: view.frame.midX - 150, y: view.frame.midY + 200, width: 300, height: 60)
            let button = UIButton(frame: buttonFrame)
            button.backgroundColor = UIColor.systemGreen
            button.setTitle("Confirm Sale with User", for: .normal)
            button.addTarget(self, action: #selector(confirm), for: .touchUpInside)
            view.addSubview(button)
        }
        
        let theNextFrame = CGRect(x: view.frame.minX+10, y: view.frame.midY-260, width: view.frame.maxX, height: 60)
             let eventName = UILabel(frame: theNextFrame)
             eventName.text = nameOfEvent
             eventName.font = UIFont.init(name: "avenir", size: 30)
             eventName.textAlignment = .left
             eventName.numberOfLines = 2
             view.addSubview(eventName)
        
        let anotherFrame = CGRect(x: view.frame.minX+10, y: view.frame.midY-160, width: view.frame.maxX, height: 60)
             let eventDate = UILabel(frame: anotherFrame)
             eventDate.text = dateOf
             eventDate.font = UIFont.init(name: "avenir", size: 30)
             eventDate.textAlignment = .left
             eventDate.numberOfLines = 2
             view.addSubview(eventDate)
        
        let aFrame = CGRect(x: view.frame.minX+10, y: view.frame.midY-80, width: view.frame.maxX, height: 60)
             let priceOf = UILabel(frame: aFrame)
             priceOf.text = "$\(price ?? "0.00")"
             priceOf.font = UIFont.init(name: "avenir", size: 30)
             priceOf.textAlignment = .left
             view.addSubview(priceOf)
        
        let headerFrame = CGRect(x: view.frame.minX+10, y: view.frame.midY-300, width: view.frame.maxX, height: 60)
            let header = UILabel(frame: headerFrame)
            header.text = "\(sellerName ?? "The seller") is looking to a sell a ticket to"
            header.numberOfLines = 2
            header.font = UIFont.systemFont(ofSize: 20)
            header.textColor =  UIColor.systemGray2
            header.textAlignment = .left
            view.addSubview(header)
        
        let onFrame = CGRect(x: view.frame.minX+10, y: view.frame.midY-190, width: view.frame.maxX, height: 60)
           let on = UILabel(frame: onFrame)
           on.text = "on"
           on.font = UIFont.init(name: "avenir", size: 20)
           on.textColor =  UIColor.systemGray2
           on.textAlignment = .left
          view.addSubview(on)
        
        let forFrame = CGRect(x: view.frame.minX+10, y: view.frame.midY-110, width: view.frame.maxX, height: 60)
        let forLabel = UILabel(frame: forFrame)
            forLabel.text = "for"
            forLabel.font = UIFont.init(name: "avenir", size: 20)
            forLabel.textColor =  UIColor.systemGray2
            forLabel.textAlignment = .left
            view.addSubview(forLabel)
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


