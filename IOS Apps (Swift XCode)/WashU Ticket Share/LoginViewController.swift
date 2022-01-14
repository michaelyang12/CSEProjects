//
//  LoginViewController.swift
//  WashU Ticket Share
//
//  Created by Michael Yang on 11/15/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    
    @IBAction func enterEmail(_ sender: Any) {
    }
    
    @IBAction func enterPassword(_ sender: Any) {
    }
    
    @IBAction func loginAction(_ sender: Any) {
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
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { result, error in
            guard error == nil else {
                let alert = UIAlertController(title: "Login Failed", message: "Make sure information is correct and try again", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            
            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            self.email.text = ""
            self.password.text = ""
        })
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
