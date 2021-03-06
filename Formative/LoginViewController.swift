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


    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var passwordFieldYConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let user = PFUser.currentUser()
        {
            user.fetch()
            
            // Direct user to correct location
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
            passwordFieldYConstraint.constant = view.bounds.height/4
            UIView.animateWithDuration(1.0, animations: {
                self.view.layoutIfNeeded()
                self.logo.alpha = 0
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
            // Done button (Animate fields down)
            self.passwordFieldYConstraint.constant = 0
            UIView.animateWithDuration(1.0, animations: {
                self.view.layoutIfNeeded()
                self.logo.alpha = 1
                textField.resignFirstResponder()

            })
        }
        
        return true
    }

    @IBAction func loginButtonTouched() {
        spinner.startAnimating()
        
        PFUser.logInWithUsernameInBackground(nameTextField.text, password:passwordTextField.text) {
            (user: PFUser?, error: NSError?) -> Void in
            self.spinner.stopAnimating()
            if let error = error {
                let errorString = error.userInfo?["error"] as? String
                
                alertErrorWithTitle("Login Failed", message: errorString, inViewController: self)
                
            }
            else {
                var currentInstallation = PFInstallation.currentInstallation() // For push notifications
                if (user!["completedSetup"] as! Bool) {
                    
                    currentInstallation["PWDid"] = user!["PWDid"]
                    currentInstallation["userId"] = user?.objectId
                    currentInstallation.saveInBackground()
                    
                    self.performSegueWithIdentifier("goToTabBar", sender: nil)
                } else {
                    
                    currentInstallation["userId"] = user?.objectId
                    currentInstallation.saveInBackground()
                    
                    self.performSegueWithIdentifier("resumeSetup", sender: nil)
                }
                
            }
        }
    }

}
