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
    
    @IBOutlet weak var test: UILabel!
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

    @IBAction func ChangeLbl(sender: AnyObject) {
        if controller.selectedSegmentIndex == 0 {   // Posting Questions
            // Show table view
            test.text = "1: questions"
        }
        if controller.selectedSegmentIndex == 1 {    // Posting Updates
            test.text = "2: update"
        }
    }
}
