//
//  AdminViewViewController.swift
//  Formative
//
//  Created by Jihoon Kim on 7/30/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

class AdminViewViewController: UIViewController {
    @IBOutlet weak var controller: UISegmentedControl!
    @IBOutlet weak var sendToSelected: UIButton!
    @IBOutlet weak var sendToAll: UIButton!
    
    
    @IBOutlet weak var postQuestions: UIView!
    @IBOutlet weak var postUpdates: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func ChangeLbl(sender: UISegmentedControl) {
        switch controller.selectedSegmentIndex {
        case 0:         // Post questions
            postQuestions.hidden = false
            postUpdates.hidden = true
        case 1:         // Post Updates
            postQuestions.hidden = true
            postUpdates.hidden = false
        default:
            break
        }
    }
}
