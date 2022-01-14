//
//  TicketListingsViewController.swift
//  WashU Ticket Share
//
//  Created by lecohen on 11/24/21.
//

import UIKit
import Firebase
import FirebaseAuth

class TicketListingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tickets: [Ticket] = []
    
    @IBOutlet weak var ticketTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("reload \(tickets.count)")
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ticket", for: indexPath) as! TicketTableViewCell
        let eventName = tickets[indexPath.row].eventName
        cell.event.text = eventName
        cell.date.text = tickets[indexPath.row].eventDate
        cell.price.text = tickets[indexPath.row].price
        cell.seller.text = tickets[indexPath.row].usernamePosted
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    var username = "asdf"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ticketTableView.dataSource = self
        ticketTableView.delegate = self
        pullTickets()
        
        let rootRef = Database.database().reference()

        guard let currentUser = FirebaseAuth.Auth.auth().currentUser else {
            return
        }
        // User is signed in.
        let userid = currentUser.uid
        
        //get seller name
        rootRef.child("users/\(userid)").observe(.value, with: { snapshot in
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                let snap = snapshot
                let dict = snap.value as! [String: Any]
                self.username = dict["name"] as? String ?? "Unknown"
            }
            self.ticketTableView.reloadData()
        })

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.pullTickets()
    }
    
    func pullTickets() {
        let rootRef = Database.database().reference()
        rootRef.child("tickets").observe(.value, with: { snapshot in
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                var newTickets: [Ticket] = []
                for child in snapshot.children {
               
                    let snap = child as! DataSnapshot
                    let newTicket = Ticket(snapshot: snap)
                    if(newTicket.sold == false){
                        newTickets.append(newTicket)
                    }
                }
                self.tickets = newTickets
                print(newTickets)
            }
            self.ticketTableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedVC = DetailedTicketViewController()
        detailedVC.id = tickets[indexPath.row].id
        detailedVC.nameOfEvent = tickets[indexPath.row].eventName
        detailedVC.dateOf = tickets[indexPath.row].eventDate
        detailedVC.price =  tickets[indexPath.row].price
        detailedVC.sellerName = tickets[indexPath.row].usernamePosted
        detailedVC.sellerID = tickets[indexPath.row].userIdPosted
        detailedVC.buyerName = self.username
        guard let currentUser = FirebaseAuth.Auth.auth().currentUser else {
            return
        }
        // User is signed in.
        let userID = currentUser.uid
        detailedVC.buyerID = userID
        navigationController?.pushViewController(detailedVC, animated: true)

//        let rootRef = Database.database().reference()
//        rootRef.child("users/\(userID)/name").getData(completion:  { error, snapshot in
//            print("room exists, going to room...")
//            guard error == nil else {
//                print(error!.localizedDescription)
//                return
//            }
//            let buyerName = self.username
//            let detailedVC = DetailedTicketViewController()
//            detailedVC.nameOfEvent = self.tickets[indexPath.row].eventName
//            detailedVC.dateOf = self.tickets[indexPath.row].eventDate
//            detailedVC.price =  self.tickets[indexPath.row].price
//            detailedVC.sellerName = self.tickets[indexPath.row].usernamePosted
//            detailedVC.sellerID = self.tickets[indexPath.row].userIdPosted
//            detailedVC.buyerName = buyerName
//            self.navigationController?.pushViewController(detailedVC, animated: true)
//        })
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

                    
