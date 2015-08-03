//
//  NewUserViewController.swift
//  Formative
//
//  Created by Andrew Ke on 7/22/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import Bolts
import Parse

class NewUserViewController: UIViewController {

    @IBOutlet weak var newUserLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var invitationTextField: UITextField!
    @IBOutlet weak var passwordFieldYConstraint: NSLayoutConstraint!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // Called whenever a user taps on a text field
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if (passwordFieldYConstraint.constant == 40) {
            // Animate fields up
            println("UP")
            passwordFieldYConstraint.constant = view.bounds.height/4 - 10
            UIView.animateWithDuration(1.0, animations: {
                self.view.layoutIfNeeded()
                self.newUserLabel.alpha = 0
            })
        }
        return true
    }
    
    // Called when the user presses the return key at the bottom right corner (it is a Next or Done key in this case)
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == emailTextField) {
            // Next button
            passwordTextField.becomeFirstResponder()
        }
        else if (textField == passwordTextField) {
            confirmPasswordTextField.becomeFirstResponder()
        }
        else if (textField == confirmPasswordTextField){
            invitationTextField.becomeFirstResponder()
        }
        else {
            println("Down")
            // Done button (Animate fields down)
            self.passwordFieldYConstraint.constant = 40
            UIView.animateWithDuration(1.0, animations: {
                self.view.layoutIfNeeded()
                self.newUserLabel.alpha = 1
                textField.resignFirstResponder()
            })
        }
        
        return true
    }

    @IBAction func signUpButtonPressed() {
        var user = PFUser()
        user["completedSetup"] = false
        user.username = emailTextField.text
        user.email = emailTextField.text
        user.password = passwordTextField.text
        user["PWDid"] = invitationTextField.text
        
        if (passwordTextField.text != confirmPasswordTextField.text) {
            alertErrorWithTitle("Passwords do not match", message: "Please double check you password confirmation.", inViewController: self)
        }
        
        spinner.startAnimating()
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? String
                self.spinner.stopAnimating()
                alertErrorWithTitle("Account Creation Failed", message: errorString, inViewController: self)
                
            } else {
                self.spinner.stopAnimating()
                self.performSegueWithIdentifier("goToSetup", sender: nil)
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
