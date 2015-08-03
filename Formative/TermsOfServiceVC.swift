//
//  TermsOfServiceVC.swift
//  Formative
//
//  Created by Andrew Ke on 8/2/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

class TermsOfServiceVC: UIViewController {

    @IBOutlet weak var agreementSegmentedControl: UISegmentedControl!
    
    @IBAction func nextPressed(sender: AnyObject) {
        
        if (agreementSegmentedControl.selectedSegmentIndex == 1) {
            // I disagree selected
            alertErrorWithTitle("Please agree with our terms.", message: nil, inViewController: self)
        }
        else {
            performSegueWithIdentifier("goToInstructions", sender: nil)
        }
    }
}
