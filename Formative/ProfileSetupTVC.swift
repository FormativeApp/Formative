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
    
    var patient = PFObject(className: "Patient")
    
    var textCells: Array<TextFieldCell> = []
    var multipleChoiceCells: Array<MultipleChoiceCell> = []
    var profileImageCell: ProfilePictureSelectionCell!
    
    // MARK: - VC Lifecycle
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
    
    // MARK: - Table View Data Source
    
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
            cell.title = questions[indexPath.row-1][0] as! String
            multipleChoiceCells.append(cell)
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0){
            println("YES!")
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
            println("Sucess!")
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
            let imageFile:PFFile = PFFile(data: imageData)
            PFUser.currentUser()?.setObject(imageFile, forKey: "profileImage")
            PFUser.currentUser()?.saveInBackground()
            
        }
        profileImageCell.profileImage.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Parse Integration
    @IBAction func profileSetupFInished(sender: AnyObject) {
        var user = PFUser.currentUser()!
        /*println(textCells.count)
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
        }*/
        
        performSegueWithIdentifier("goToMain", sender: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var user = PFUser.currentUser()!
        user.save()
    }

}
