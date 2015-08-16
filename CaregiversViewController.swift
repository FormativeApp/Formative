//
//  CaregiversViewController.swift
//  Formative
//
//  Shows user's care team and allows user to invite more people to their care team
//
//  Created by Andrew Ke on 8/5/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import Parse
import MessageUI

class CaregiversViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var invitationTextView: UITextView! // Text View to make it text selectable
    
    // Storage space for query result
    var users: Array<PFUser> = []
    

    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        var user = PFUser.currentUser()!
        
        invitationTextView.text = "Invitation Code: " + (user["PWDid"] as! String)
        
        // Query for users
        var query = PFUser.query()
        query?.whereKey("PWDid", equalTo: user["PWDid"] as! String)
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            self.users = objects as! Array<PFUser>
            self.collectionView.reloadData()
        })
        
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Using tags to avoid subclassing
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("userCell", forIndexPath: indexPath) as! UICollectionViewCell
        (cell.viewWithTag(2) as! UILabel).text = users[indexPath.row]["fullName"] as? String
        var image = (cell.viewWithTag(1) as! CircularImageView)
        
        image.file = users[indexPath.row]["profileImage"] as? PFFile
        image.backgroundColor = UIColor.grayColor()
        image.loadInBackground()
        
        return cell
    }
    
    // MARK: - Invite sending

    @IBAction func addNewMembers() {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setSubject("Welcome to Formative!")
        var code = PFUser.currentUser()!["PWDid"] as! String
        mailComposerVC.setMessageBody("Welcome To Formative!  Your invitation code: \(code)", isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            presentViewController(mailComposerVC, animated: true, completion: nil)
        } else {
            alertErrorWithTitle("Mail sending is not enabled on this device. Please enable it.", message: nil, inViewController: self)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        println(result.value)
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
