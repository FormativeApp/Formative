//
//  InviteSenderViewController.swift
//  Formative
//
//  Created by Andrew Ke on 8/2/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import Foundation
import Parse
import Bolts
import MessageUI

// Sends invites and displays invitation code
class InviteSenderViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var patientID: UITextView!
    
    override func viewDidLoad() {
        var user = PFUser.currentUser()!
        var PWDid = user["PWDid"] as! String
        patientID.text = PWDid
        user["completedSetup"] = true
        user.saveInBackground()
    }


    @IBAction func sendEmails() {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setSubject("Welcome to Formative!")
        mailComposerVC.setMessageBody("Welcome To Formative!  Your invitation code: \(patientID.text!)", isHTML: false)
        if MFMailComposeViewController.canSendMail() {
            presentViewController(mailComposerVC, animated: true, completion: nil)
        } else {
           alertErrorWithTitle("Mail sending is not enabled on this device. Please enable it.", message: nil, inViewController: self)
        }
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
