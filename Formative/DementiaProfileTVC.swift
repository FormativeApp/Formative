//
//  DementiaProfileTVC.swift
//  Formative
//
//  Created by Andrew Ke on 8/4/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import MobileCoreServices
import Parse

class DementiaProfileTVC: UITableViewController{
    
    var questions: NSArray!
    
    var patient:PFObject?
    
    var user = PFUser.currentUser()!
    
    var numberOfTextQuestions = 4
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var patientID = user["PWDid"] as! String
        PFQuery(className: "Patient").getObjectInBackgroundWithId(patientID, block: { (object, error) -> Void in
            self.patient = object
            self.tableView.reloadData()
        })
        
        // load questions from .json file
        var questionsData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("userProfileQuestions", ofType: "json")!)
        questions = parseJSON(questionsData!) as! NSArray
        
        // Configure for self sizing cells
        tableView.estimatedRowHeight = 2
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        var patientID = user["PWDid"] as! String
        PFQuery(className: "Patient").getObjectInBackgroundWithId(patientID, block: { (object, error) -> Void in
            self.patient = object
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table View Data Source/ Delegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        var mainText = ""
        var detailText = ""
        
        if (indexPath.row < numberOfTextQuestions)
        {
            
            detailText = (questions[indexPath.row][1] as? String)!
            mainText = "NA"
            
            if let patient = patient
            {
                if let lastValue = patient[questions[indexPath.row][0] as! String] as? String {
                    mainText = lastValue
                }
            }
        }
        else
        {
            mainText = "NA"
            detailText = (questions[indexPath.row][0] as! NSString).substringFromIndex(3)
            if let patient = patient
            {
                if let lastValue = patient[questions[indexPath.row][0] as! String] as? Int {
                    if (lastValue >= 0)
                    {
                        mainText = questions[indexPath.row][1][lastValue] as! String
                    }
                }
            }
        }
        
        cell.textLabel?.text = mainText
        cell.detailTextLabel?.text = detailText
        
        return cell
    }
    
}


