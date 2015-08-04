//
//  InstructionsVC.swift
//  Formative
//
//  Created by Andrew Ke on 8/2/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import Parse

class InstructionsVC: UIViewController {
    
    // Disable back button
    override func viewDidLoad() {
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @IBAction func nextPressed(sender: AnyObject) {
        if (PFUser.currentUser()!["invited"] as! Bool == true) {
            performSegueWithIdentifier("goToInvitedSetup", sender: nil)
        }
        else {
            performSegueWithIdentifier("goToFullSetup", sender: nil)
        }
    }
    
}
