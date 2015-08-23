//
//  ForgotPasswordVC.swift
//  Formative
//
//  Created by Andrew Ke on 8/2/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import Bolts
import Parse

class ForgotPasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func submitPressed() {
        spinner.startAnimating()
        PFUser.requestPasswordResetForEmailInBackground(emailTextField.text, block: { (success, error) -> Void in
            self.spinner.stopAnimating()
            if (success) {
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
            else {
                alertErrorWithTitle("Reset failed.", message: error!.userInfo?["error"] as? String, inViewController: self)
            }
        })
    }
}
