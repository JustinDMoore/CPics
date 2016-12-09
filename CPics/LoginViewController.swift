//
//  LoginViewController.swift
//  CPics
//
//  Created by Justin Moore on 12/8/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    
    @IBOutlet weak var txtusername: UITextField!
    @IBOutlet weak var txtpassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var progressLogIn: UIActivityIndicatorView!
    @IBOutlet weak var lblAlertSignIn: UILabel!
    
    let Server = ParseServer.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressLogIn.isHidden = true
        lblAlertSignIn.text = ""
    }

    @IBAction func btnSignIn_Click(_ sender: UIButton) {
        signIn()
    }
    
    func signIn() {
        txtpassword.resignFirstResponder()
        progressLogIn.startAnimating()
        btnSignIn.isEnabled = false
        
        // Validate the text fields
        if (txtusername.text?.characters.count)! < 1 {
            lblAlertSignIn.text = "Invalid Email"
            lblAlertSignIn.isHidden = false
            progressLogIn.stopAnimating()
            progressLogIn.isHidden = true
            btnSignIn.isEnabled = true
            return
        } else if (txtpassword.text?.characters.count)! < 1 {
            lblAlertSignIn.text = "Invalid Password"
            lblAlertSignIn.isHidden = false
            progressLogIn.stopAnimating()
            progressLogIn.isHidden = true
            btnSignIn.isEnabled = true
            return
        }
        
        progressLogIn.isHidden = false
        progressLogIn.startAnimating()
        
        PFUser.logInWithUsername(inBackground: (txtusername.text?.lowercased())!, password: txtpassword.text!) {(user, error) in
            if let err = error {
        
                // error handling
                self.lblAlertSignIn.text = "\(err.localizedDescription)"
                self.lblAlertSignIn.isHidden = false
                self.progressLogIn.stopAnimating()
                self.progressLogIn.isHidden = true
                self.btnSignIn.isEnabled = true
            } else if let user = user {
                let authorized = user["auditionAccess"] as? Bool
                if authorized != true {
                    //no access
                    self.lblAlertSignIn.text = "Your account is pending authorization."
                    self.lblAlertSignIn.isHidden = false
                    PFUser.logOutInBackground()
                    self.btnSignIn.isEnabled = true
                } else {
                    self.loggedIn()
                }
                
                self.progressLogIn.stopAnimating()
                self.progressLogIn.isHidden = true
                
                self.txtusername.text = ""
                self.txtpassword.text = ""
                self.btnSignIn.isEnabled = true
            }
        }
    }
    
    func loggedIn() {
        self.performSegue(withIdentifier: "menu", sender: self)
    }


}
