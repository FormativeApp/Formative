//
//  ChangePasswordVC.swift
//  Formative
//
//  Created by Andrew Ke on 8/4/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import Parse

class ChangePasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmNewPassword: UITextField!


    @IBAction func donePressed(sender: AnyObject) {
        
        if (newPassword.text == "")
        {
            navigationController?.popViewControllerAnimated(true)
            return
        }
        
        if (newPassword.text != confirmNewPassword.text){
            alertErrorWithTitle("Passwords do not match", message: nil, inViewController: self)
            return
        }
        
        var user = PFUser.currentUser()!
        user.password = newPassword.text
        
        user.saveInBackground()
        navigationController?.popViewControllerAnimated(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
