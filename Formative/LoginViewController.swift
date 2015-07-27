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
        PFUser.logInWithUsernameInBackground(nameTextField.text, password:passwordTextField.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.performSegueWithIdentifier("goToProfileSetup", sender: nil)
            } else {
                var alert = UIAlertController(title: "Login Failed", message: error?.userInfo?.description, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
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
