//
//  LoginViewController.swift
//  Formative
//
//  Created by Andrew Ke on 7/22/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import Parse
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var passwordFieldYConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let user = PFUser.currentUser()
        {
            println("ding!")
            user.fetch()
            println(user)
            if (user["completedSetup"] as! Bool) {
                self.performSegueWithIdentifier("goToTabBar", sender: nil)
            }
            else {
                self.performSegueWithIdentifier("resumeSetup", sender: nil)
            }
        }

    }
    // Called whenever a user taps on a text field
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if (passwordFieldYConstraint.constant == 0) {
            
            // Animate fields up
            println("UP")
            passwordFieldYConstraint.constant = view.bounds.height/4
            UIView.animateWithDuration(1.0, animations: {
                self.view.layoutIfNeeded()
                self.loginLabel.alpha = 0
            })
        }
        return true
    }
    
    // Called when the user presses the return key at the bottom right corner (it is a Next or Done key in this case)
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // Make keyboard dismiss
        
        if (textField == nameTextField) {
            // Next button
            passwordTextField.becomeFirstResponder()
        }
        else {
            println("Down")
            // Done button (Animate fields down)
            self.passwordFieldYConstraint.constant = 0
            UIView.animateWithDuration(1.0, animations: {
                self.view.layoutIfNeeded()
                self.loginLabel.alpha = 1
                textField.resignFirstResponder()
            })
        }
        
        return true
    }

    @IBAction func loginButtonTouched() {
        spinner.startAnimating()
        println("\(nameTextField.text), \(passwordTextField.text)")
        PFUser.logInWithUsernameInBackground(nameTextField.text, password:passwordTextField.text) {
            (user: PFUser?, error: NSError?) -> Void in
            self.spinner.stopAnimating()
            if let error = error {
                let errorString = error.userInfo?["error"] as? String
                
                alertErrorWithTitle("Login Failed", message: error.description, inViewController: self)
                
            } else {
                if (user!["completedSetup"] as! Bool) {
                    self.performSegueWithIdentifier("goToTabBar", sender: nil)
                } else {
                    self.performSegueWithIdentifier("resumeSetup", sender: nil)
                }
                
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
