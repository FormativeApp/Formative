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

class ProfileSetupTVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImage: CircularImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    var questions: NSArray!
    
    var textCells: Array<TextFieldCell> = []
    var multipleChoiceCells: Array<MultipleChoiceCell> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var questionsData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("userProfileQuestions", ofType: "json")!)
        questions = parseJSON(questionsData!) as! NSArray
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profileSetupFInished(sender: AnyObject) {
        var user = PFUser.currentUser()!
        println(textCells.count)
        for cell in textCells{
            if (cell.textField.text == "")
            {
                alertErrorWithTitle("Incomplete Profile", message: "Required field \(cell.textField.placeholder!) was not filled in", inViewController: self)
                return
            }
            user["\(cell.key!)"] = cell.textField.text
        }
        
        for cell in multipleChoiceCells{
            if cell.selection == -1 {
                alertErrorWithTitle("Incomplete Profile", message: "Required multiple choice question \(cell.title) was not filled in", inViewController: self)
                return
            }
            user["\(cell.title)"] = cell.selection
        }
        
        performSegueWithIdentifier("goToMain", sender: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var user = PFUser.currentUser()
        user?.save()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return questions.count + 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("LOAD!!!!!")
        if (indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("photoCell", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
        else if (indexPath.row < 6)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("questionCell", forIndexPath: indexPath) as! TextFieldCell
            cell.textField.placeholder = questions[indexPath.row-1][1] as? String
            cell.key = questions[indexPath.row-1][0] as? String
            textCells.append(cell)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("multipleCell", forIndexPath: indexPath) as! MultipleChoiceCell
            cell.array = questions[indexPath.row-1][1] as! Array<String>
            cell.title = questions[indexPath.row-1][0] as! String
            multipleChoiceCells.append(cell)
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0){
            println("YES!")
            var alert = UIAlertController(title: "Choose A Source", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Camera Roll", style: .Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */

}
