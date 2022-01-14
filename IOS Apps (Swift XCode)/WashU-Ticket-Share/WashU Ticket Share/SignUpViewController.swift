//
//  SignUpViewController.swift
//  WashU Ticket Share
//
//  Created by Michael Yang on 11/15/21.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var signIn: UIButton!
    
    @IBAction func enterName(_ sender: Any) {
    }
    @IBAction func enterEmail(_ sender: Any) {
    }
    @IBAction func enterPassword(_ sender: Any) {
    }
    @IBAction func enterConfirm(_ sender: Any) {
    }
    @IBAction func signInAction(_ sender: Any) {
//        //hardcode messages test remove later
//        let rootRef = Database.database().reference()
//        let addRoomRef = rootRef.child("messageRooms")
//        let roomid = "zXlpjUnejKX0PW6rtWTGn8LQ2Ch25jc76DBJWSSQCBMNF5wBwxnVE7L2"
//
////        let user1: User = User(uid: "zXlpjUnejKX0PW6rtWTGn8LQ2Ch2", name: "Jonathan Song", rating: 0, transactions: 0)
////        let user2: User = User(uid: "5jc76DBJWSSQCBMNF5wBwxnVE7L2", name: "Michael", rating: 0, transactions: 0)
//        print("RIGHT BEFORE")
//
////        let message:Message = Message(dateSent: "", messageText: "hello world!", roomID: roomid, timeSent: "", userReceived: user1, userSent: user2)
//        let message = [
//            "messageText": "First message",
//            "roomID": roomid,
//            "userReceivedID": "5jc76DBJWSSQCBMNF5wBwxnVE7L2",
//            "userReceivedName": "Michael",
//            "userSentID": "zXlpjUnejKX0PW6rtWTGn8LQ2Ch2",
//            "userSentName": "Jonathan Song"]
//
//
//        addRoomRef.child(roomid).setValue([
//            "id":roomid,
//            "last message date": "",
//            "last message time": "",
//            "user1id": "zXlpjUnejKX0PW6rtWTGn8LQ2Ch2",
//            "user1name": "Jonathan Song",
//            "user2id": "5jc76DBJWSSQCBMNF5wBwxnVE7L2",
//            "user2name": "Michael",
//            "messages": [message]
//        ])
//        //***** end test
        
        guard let name = name.text, !name.isEmpty else {
            let alert = UIAlertController(title: "Invalid Name", message: "Enter a new name", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let email = email.text, !email.isEmpty else {
            let alert = UIAlertController(title: "Invalid Email", message: "Enter a new email", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let password = password.text, !password.isEmpty else {
            let alert = UIAlertController(title: "Invalid Password", message: "Enter a new password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (password.count < 6 || password.count > 20) {
            let alert = UIAlertController(title: "Invalid Password", message: "Password must be between 6 and 20 characters", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let confirmPassword = confirmPassword.text, !confirmPassword.isEmpty else {
            let alert = UIAlertController(title: "Did not confirm password", message: "Reenter your desired password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (password != confirmPassword) {
            let alert = UIAlertController(title: "Passwords do not match", message: "Make sure your passwords match", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
           return
        }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                let alert = UIAlertController(title: "Error with creating a user", message: "Try again", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            // signed in
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { result, error in
                guard error == nil else {
                    let alert = UIAlertController(title: "Error with signing in new user", message: "Try signing in your new user", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                
                // This is to get the SceneDelegate object from your view controller
                // then call the change root view controller function to change to main tab bar
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                
                guard let result = result else {
                    let alert = UIAlertController(title: "Error with signing in new user", message: "Try signing in your new user", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                let userid = result.user.uid
                let rootRef = Database.database().reference()
                let addUserRef = rootRef.child("users")

                addUserRef.child(userid).setValue(["uid": userid, "name":name, "number of successful transactions": 0, "average rating": 5.0, "ratings": [5]])
                
                self.confirmPassword.text = ""
                self.password.text = ""
                self.email.text = ""
                self.name.text = ""
                
            })
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
