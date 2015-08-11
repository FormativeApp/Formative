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
import MobileCoreServices

class ProfileSetupTVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var questions: NSArray!
    
    var selections = [-1, -1, -1, -1, -1, -1]
    
    var patient:PFObject?
    
    var textCells: Array<TextFieldCell> = []
    var profileImageCell: ProfilePictureSelectionCell!
    
    var user = PFUser.currentUser()!
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
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
        
        clearsSelectionOnViewWillAppear = false
    }
    
    // MARK: - Table View Data Source/ Delegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row < 5)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("questionCell", forIndexPath: indexPath) as! TextFieldCell
            cell.key = questions[indexPath.row][0] as? String
            cell.label.text = questions[indexPath.row][1] as? String
            if let patient = patient
            {
                if let lastValue = patient[cell.key!] as? String {
                    cell.textField.text = lastValue
                }
                else if let lastValue = user[cell.key!] as? String {
                    cell.textField.text = lastValue
                }
            }
            textCells.append(cell)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("multipleCell", forIndexPath: indexPath) as! MultipleChoiceCell
            cell.array = questions[indexPath.row][1] as! Array<String>
            cell.title = (questions[indexPath.row][0] as! NSString).substringFromIndex(3)
            cell.selection = selections[indexPath.row-5]
            if (cell.selection == -1)
            {
                if let patient = patient
                {
                    if let lastValue = patient[questions[indexPath.row][0] as! String] as? Int {
                        cell.selection = lastValue
                    }
                }
            }
            cell.heightConstraint.constant = 353.5
            return cell
        }

    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row >= 5) {
            selections[indexPath.row-5] = (cell as! MultipleChoiceCell).selection
        }
    }
    
    // MARK: - Seguing
    @IBAction func profileSetupFinished(sender: AnyObject) {
        //println(selections)
        if let patient = patient
        {
            var user = PFUser.currentUser()!
            
            for cell in textCells
            {
                patient["\(cell.key!)"] = cell.textField.text as String
            }
            
            println(selections)
            
            for i in 5..<selections.count+5 {
                var cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? MultipleChoiceCell
                if let cell = cell {
                    selections[i-5] = cell.selection
                }
                patient[questions[i][0] as! String] = selections[i-5]
            }
            
            patient.saveInBackground()
            user.saveInBackground()
            
            navigationController?.popViewControllerAnimated(true)
        }

    }

}
