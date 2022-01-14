
//
//  RatingViewController.swift
//  WashU Ticket Share
//

//  Created by Jade Wang on 12/6/21.
//

import UIKit
import Firebase
import FirebaseAuth

class RatingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var reviews: [InboxItem] = []
    var username = "asdf"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        guard let user = Auth.auth().currentUser else {
            return
        }
        let rootRef = Database.database().reference()
        guard let currentUser = FirebaseAuth.Auth.auth().currentUser else {
            return
        }
        // User is signed in.
        let userid = currentUser.uid
        
//        rootRef.child("users/\(userid)").observe(.value, with: { snapshot in
//            if ( snapshot.value is NSNull ) {
//                print("not found")
//            } else {
//                let snap = snapshot
//                let dict = snap.value as! [String: Any]
//                self.username = dict["name"] as? String ?? "Unknown"
//            }
//        })
        rootRef.child("inbox").observe(.value, with: { snapshot in
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                var tempItems: [InboxItem] = []
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String: Any]
                    guard let tempBuyerID = dict["buyerID"] as? String else {
                        return
                    }
                    if tempBuyerID == userid {
                        let temp = InboxItem(snapshot: snap)
                        if(temp.completed == false){
                            tempItems.append(temp)
                        }
                        
                    }
                }
                self.reviews = tempItems
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath) as! RatingTableViewCell
        
        cell.eventName.text = reviews[indexPath.row].nameOfEvent
        cell.eventDate.text = reviews[indexPath.row].dateOf
        cell.sellerName.text = reviews[indexPath.row].sellerName
        cell.price.text = "$\(reviews[indexPath.row].price)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ratingVC = submitRatingViewController()
        
        ratingVC.buyerName = reviews[indexPath.row].buyerName
        ratingVC.buyerID = reviews[indexPath.row].buyerID
        ratingVC.sellerName = reviews[indexPath.row].sellerName
        ratingVC.sellerID =  reviews[indexPath.row].sellerID
        ratingVC.nameOfEvent = reviews[indexPath.row].nameOfEvent
        ratingVC.dateOf = reviews[indexPath.row].dateOf
        ratingVC.price = reviews[indexPath.row].price
        ratingVC.completed = reviews[indexPath.row].completed
        ratingVC.id = reviews[indexPath.row].id
        navigationController?.pushViewController(ratingVC, animated: true)
        
    }
}


