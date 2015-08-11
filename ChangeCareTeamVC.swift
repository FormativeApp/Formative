//
//  ChangeCareTeamVC.swift
//  Formative
//
//  Created by Andrew Ke on 8/10/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import Parse

class ChangeCareTeamVC: UIViewController {

    @IBOutlet weak var invitationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func donePressed(sender: AnyObject) {
        if (invitationTextField.text == "")
        {
            navigationController?.popViewControllerAnimated(true)
            return
        }
        
        var user = PFUser.currentUser()!
        user["PWDid"] = invitationTextField.text
        user.saveInBackground()
        
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
