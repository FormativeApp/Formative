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
    
    @IBOutlet weak var profileImage: CircularImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    var questions: NSArray!
    
    var selections = [-1, -1, -1, -1, -1, -1]
    
    var patient = PFObject(className: "Patient")
    
    var textCells: Array<TextFieldCell> = []
    var profileImageCell: ProfilePictureSelectionCell!
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load questions from .json file
        var questionsData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("userProfileQuestions", ofType: "json")!)
        questions = parseJSON(questionsData!) as! NSArray
        // Configure for self sizing cells
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        clearsSelectionOnViewWillAppear = false
    }
    
    // MARK: - Table View Data Source/ Delegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count + 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("photoCell", forIndexPath: indexPath) as! ProfilePictureSelectionCell
            profileImageCell = cell
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
            cell.title = (questions[indexPath.row-1][0] as! NSString).substringFromIndex(3)
            cell.selection = selections[indexPath.row-6]
            cell.heightConstraint.constant = 325
            cell.selections = selections
            cell.index = indexPath.row-6
            return cell
        }

    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        println(selections)
        if (indexPath.row >= 6) {
            selections[indexPath.row-6] = (cell as! MultipleChoiceCell).selection
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0){ // Photo cell touched
            
            // Create an alert
            var alert = UIAlertController(title: "Choose A Source", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (action) in
                self.takePhoto()
            }))
            alert.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (action) in
                self.photoFromCameraRoll()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Image Picker
    
    func takePhoto()
    {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .Camera
            // if we were looking for video, we'd check availableMediaTypes
            picker.mediaTypes = [kUTTypeImage]
            picker.delegate = self
            picker.allowsEditing = true
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func photoFromCameraRoll()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            println("success!")
            let picker = UIImagePickerController()
            picker.sourceType = .PhotoLibrary
            picker.mediaTypes = [kUTTypeImage]
            picker.delegate = self
            picker.allowsEditing = true
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        } else {
            // [Jihoon]: convert the image to binary, and save to the Parse cloud
            let imageData = UIImagePNGRepresentation(image) //takes the image and converts it to the binary code
            let imageFile = PFFile(data: imageData)
            PFUser.currentUser()!["profileImage"] = imageFile
        }
        profileImageCell.profileImage.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Seguing
    @IBAction func profileSetupFinished(sender: AnyObject) {
        println(selections)
        
        var user = PFUser.currentUser()!
        
        for cell in textCells{
            if (cell.textField.text == "")
            {
                alertErrorWithTitle("Incomplete Profile", message: "Required field \"\(cell.textField.placeholder!)\" was not filled in.", inViewController: self)
                return
            }
            if (cell.key == "name")
            {
                var nameSplit = split(cell.textField.text) {$0 == " "}
                println(nameSplit)
                
                if (nameSplit.count != 2) {
                    alertErrorWithTitle("Invalid Name", message: "Please add both your first and last name.", inViewController: self)
                    return
                }
                
                user["name"] = nameSplit[0]
                user["fullName"] = cell.textField.text
                
                
            }
            else {
                patient["\(cell.key!)"] = cell.textField.text
            }
        }
        
        println(selections)
        
        for i in 6..<selections.count+6 {
            var cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? MultipleChoiceCell
            if let cell = cell {
                selections[i-6] = cell.selection
            }
            if (selections[i-6] == -1) {
                alertErrorWithTitle("Please Complete the multiple choice section", message: nil, inViewController: self)
                return
            }
            else {
                patient[questions[i-1][0] as! String] = selections[i-6]
            }
        }
        
        println(selections)
        
        println(patient)
        patient.saveInBackgroundWithBlock { (success, error) -> Void in
            if (success) {
                user["PWDid"] = self.patient.objectId
                user.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if (success){
                        user["completedSetup"] = true
                        self.performSegueWithIdentifier("goToInvite", sender: nil)
                    }else {
                        alertErrorWithTitle(error!.userInfo?["error"] as! String, message: nil, inViewController: self)
                    }
                })
            } else {
                alertErrorWithTitle(error!.userInfo?["error"] as! String, message: nil, inViewController: self)
            }
        }
    }

}
