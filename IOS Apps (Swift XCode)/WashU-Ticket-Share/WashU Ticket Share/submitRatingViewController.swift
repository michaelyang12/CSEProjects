//
//  submitRatingViewController.swift
//  WashU Ticket Share
//
//  Created by lecohen on 12/6/21.
//

import UIKit
import FirebaseDatabase

class submitRatingViewController: UIViewController {

    var success = true
    var buyerName: String?
    var buyerID: String?
    var sellerName: String?
    var sellerID: String?
    var nameOfEvent: String?
    var dateOf: String?
    var price: String?
    var completed: Bool?
    var id: String?
    var sellernumber = 0
    var buyernumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let rootRef = Database.database().reference()
        
        guard let buyerID = buyerID else {
            return
        }
        guard let sellerID = sellerID else {
            return
        }
        
        //get seller name
        rootRef.child("users/\(buyerID)").observe(.value, with: { snapshot in
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                let snap = snapshot
                let dict = snap.value as! [String: Any]
                self.buyernumber = dict["number of successful transactions"] as? Int ?? 0
            }
        })
        
        rootRef.child("users/\(sellerID)").observe(.value, with: { snapshot in
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                let snap = snapshot
                let dict = snap.value as! [String: Any]
                self.sellernumber = dict["number of successful transactions"] as? Int ?? 0
            }
        })
        
        let lbl = UILabel(frame: CGRect(x: self.view.frame.midX - 135, y: self.view.frame.midY - 200, width: 270, height: 100))
        lbl.text = "Was this transaction successsful?"
        self.view.addSubview(lbl)
        
        // Initialize
          let items = ["Yes", "No"]
          let customSC = UISegmentedControl(items: items)
          customSC.selectedSegmentIndex = 0

          // Set up Frame and SegmentedControl
        let frame = CGRect(x: self.view.frame.midX - 50, y: self.view.frame.midY, width: 100, height: 40)
          customSC.frame = frame

          // Style the Segmented Control
          customSC.layer.cornerRadius = 5.0  // Don't let background bleed
//          customSC.backgroundColor = UIColor.black
//          customSC.tintColor = UIColor.white

          // Add target action method
          customSC.addTarget(self, action:  #selector(segChange), for: .valueChanged)

          // Add this custom Segmented Control to our view
          self.view.addSubview(customSC)
        
            let buttonFrame6 = CGRect(x: view.frame.midX - 105, y: view.frame.midY + 200, width: 210, height: 60)
            let button6 = UIButton(frame: buttonFrame6)
            button6.backgroundColor = UIColor.systemBlue
            button6.setTitle("Submit", for: .normal)
            button6.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        self.view.addSubview(button6)
    }
    
    @objc func segChange(_sender:UISegmentedControl!) {
        if (success) {
            success = false
        } else {
            success = true
        }
    }
    
    @objc func confirm(_sender:UIButton!) {
        if (success) {
            let rootRef = Database.database().reference()
            guard let buyerID = buyerID else {
                return
            }
            guard let sellerID = sellerID else {
                return
            }
            rootRef.child("users").child(buyerID).updateChildValues(["number of successful transactions":buyernumber + 1])
            rootRef.child("users").child(sellerID).updateChildValues(["number of successful transactions":sellernumber + 1])
            guard let id = id else {
                return
            }
            rootRef.child("inbox").child(id).updateChildValues(["completed":true])
            _ = navigationController?.popViewController(animated: true)
        } else {
            
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
