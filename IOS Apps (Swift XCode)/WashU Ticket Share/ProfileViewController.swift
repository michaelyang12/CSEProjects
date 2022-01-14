//
//  ProfileViewController.swift
//  WashU Ticket Share
//
//  Created by Jonathan Song on 11/21/21.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    //where to click to see someone else's profile?
    //where to rate someone?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var pastTransactions: [Ticket] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastTransactions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastTicket", for: indexPath) as! PastTransactionsTableViewCell
        let name = pastTransactions[indexPath.row].eventName
        cell.eventName.text = name
        cell.eventDate.text = pastTransactions[indexPath.row].eventDate
        cell.eventPrice.text = "Price: $\(pastTransactions[indexPath.row].price)"
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        guard let user = Auth.auth().currentUser else {
            return
        }
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
                var username = dict["name"] as? String ?? "Unknown"
                self.nameLabel.text = username
                let rating = dict["number of successful transactions"] as? Int ?? 0
                self.ratingLabel.text = "Successful transactions: \(String(describing: rating))"
            }
        })
        
        rootRef.child("tickets").observe(.value, with: { snapshot in
            
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                var tempTickets: [Ticket] = []
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let x = snap.childSnapshot(forPath: "userid posted").value as? String ?? ""
                    let sold = snap.childSnapshot(forPath: "sold").value as? Bool ?? false
                    if x == user.uid && sold == true{
                        let temp = Ticket(snapshot: snap)
                        tempTickets.append(temp)

                    }
                }
                self.pastTransactions = tempTickets
                self.tableView.reloadData()
            }
        })
        
//        tableView.dataSource = self
//        tableView.delegate = self
        // Do any additional setup after loading the view.
        let barButton = UIBarButtonItem()
        barButton.title = "Logout"
        barButton.action = #selector(barButtonAction)
        barButton.target = self
        self.navigationItem.setRightBarButton(barButton, animated: true) }
   
    @objc func barButtonAction() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")

            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
          
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
