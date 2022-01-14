//
//  PostViewController.swift
//  WashU Ticket Share
//
//  Created by lecohen on 11/13/21.
//

import UIKit
import Firebase
import FirebaseAuth
import Foundation

class PostViewController: UIViewController {

    @IBOutlet weak var eventInput: UITextField!
    @IBOutlet weak var priceInput: UITextField!
    @IBOutlet weak var dateInput: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    let datePicker = UIDatePicker()
    
    var username = "asdf"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        // Do any additional setup after loading the view.
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
        })
    }

    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        return toolbar
    }
    
    func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
        dateInput.inputView = datePicker
        dateInput.inputAccessoryView = createToolbar()
    }
    
    @objc func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        self.view.endEditing(true)
        self.dateInput.text = dateFormatter.string(from: datePicker.date)
    }
    
    
    @IBAction func postTicket(_ sender: Any) {

        guard let eventName = eventInput.text, !eventName.isEmpty else {
            let alert = UIAlertController(title: "Invalid Event Name", message: "Enter a new event name", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let eventDate = dateInput.text, !eventDate.isEmpty else {
            let alert = UIAlertController(title: "Invalid Date", message: "Enter a new date", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let price = priceInput.text, !price.isEmpty else {
            let alert = UIAlertController(title: "Invalid Price", message: "Enter a new price", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (!price.isNumeric){
            let alert = UIAlertController(title: "Invalid Price", message: "Price is improperly formatted", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let currentDate = dateFormatter.string(from: date)
        
        
        let rootRef = Database.database().reference()
        let addTicketRef = rootRef.child("tickets").childByAutoId()
        
        guard let currentUser = FirebaseAuth.Auth.auth().currentUser else {
            return
        }
        // User is signed in.
        let userid = currentUser.uid
        
        let interested:[String] = []
        
        addTicketRef.setValue(["date listed": currentDate, "event date": eventDate, "event name": eventName, "price":price, "userid posted": userid, "username posted": username, "sold": false, "interested": interested])
        self.dateInput.text = ""
        self.eventInput.text = ""
        self.priceInput.text = ""
        
//        rootRef.child("users/\(userid)/name").getData(completion:  { error, snapshot in
//          guard error == nil else {
//            let alert = UIAlertController(title: "Ticket Post Failed", message: "Try again", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            return
//          }
//
//            let username = snapshot.value as? String ?? "Unknown"
//            // FIX THIS
//            print(username)
//            addTicketRef.setValue(["date listed": currentDate, "event date": eventDate, "event name": eventName, "price":price, "userid posted": userid, "username posted": username, "sold": false])
//            self.dateInput.text = ""
//            self.eventInput.text = ""
//            self.priceInput.text = ""
//        });
        
    }
    
}

extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
        return Set(self).isSubset(of: nums)
    }
}
