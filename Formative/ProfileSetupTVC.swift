//
//  ProfileSetupTVC.swift
//  
//
//  Created by Andrew Ke on 7/27/15.
//
//

import UIKit
import Parse
import Bolts

class ProfileSetupTVC: UITableViewController {
    
    @IBOutlet weak var profileImage: CircularImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profileSetupFInished(sender: AnyObject) {
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var user = PFUser.currentUser()
        //user["name"] = nameTextField.text
    }

}
