//
//  CaregiversViewController.swift
//  Formative
//
//  Created by Andrew Ke on 8/5/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import Parse
import MessageUI

class CaregiversViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var invitationTextView: UITextView!
    
    var users: Array<PFUser> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var user = PFUser.currentUser()!
        
        invitationTextView.text = "Invitation Code: " + (user["PWDid"] as! String)
        var query = PFUser.query()
        query?.whereKey("PWDid", equalTo: user["PWDid"] as! String)
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            self.users = objects as! Array<PFUser>
            self.collectionView.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return users.count
        return users.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("userCell", forIndexPath: indexPath) as! UICollectionViewCell
        (cell.viewWithTag(2) as! UILabel).text = users[indexPath.row]["fullName"] as? String
        var image = (cell.viewWithTag(1) as! CircularImageView)
        image.file = users[indexPath.row]["profileImage"] as? PFFile
        image.backgroundColor = UIColor.grayColor()
        image.loadInBackground()
        return cell
    }

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
