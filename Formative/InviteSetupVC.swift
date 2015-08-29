//
//  InviteSetupVC.swift
//  Formative
//
//  Created by Andrew Ke on 8/4/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices

class InviteSetupVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate{

    @IBOutlet weak var profileImage: CircularImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var relationPicker: UIPickerView!
    
    override func viewDidLoad() {
        // Default selection
        relationPicker.selectRow(3, inComponent: 0, animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        
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
        }
    
        let imageData = UIImagePNGRepresentation(imageWithImage(image!, scaledToSize: CGSize(width: 200, height: 200))) //takes the image and converts it to the binary code
        let imageFile = PFFile(data: imageData)
        PFUser.currentUser()!["profileImage"] = imageFile
        PFUser.currentUser()!.saveInBackground()
        
        profileImage.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UIPickerDataSource
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        // Changes this along with pickerView numberOfRowsInComponent to add more choices
        return ["Spouse", "Parent", "Grandparent", "Friend", "Neighbor", "Client", "Other"][row]
    }
    
    @IBAction func done(sender: AnyObject) {
        var user = PFUser.currentUser()!
        
        // Check if name is valid
        var nameSplit = split(nameTextField.text) {$0 == " "}
        
        if (nameSplit.count != 2) {
            alertErrorWithTitle("Invalid Name", message: "Please add both your first and last name.", inViewController: self)
            return
        }
        
        user["name"] = nameSplit[0]
        user["fullName"] = nameTextField.text
        
        user["PWDrelation"] = ["Spouse", "Parent", "Grandparent", "Friend", "Neighbor", "Client", "Other"][relationPicker.selectedRowInComponent(0)]
        
        // Different options in case user was invited or not
        if (user["invited"] as? Bool == false)
        {
            // Create new patient
            var patient = PFObject(className: "Patient")
            patient.saveInBackgroundWithBlock({ (success, error) -> Void in
                
                user["PWDid"] = patient.objectId
                
                // For push notifications
                var currentInstallation = PFInstallation.currentInstallation()
                currentInstallation["PWDid"] = patient.objectId
                currentInstallation["userID"] = user.objectId
                currentInstallation.saveInBackground()
                
                // Fire of push notification
                PFCloud.callFunctionInBackground("newUserCreated", withParameters: ["name" : user["name"] as! String, "team" : user["PWDid"] as! String, "sender" : user.objectId!])
                user.saveInBackgroundWithBlock { (success, error) -> Void in
                    if (success){
                        self.performSegueWithIdentifier("goToInstructions", sender: nil)
                    }else {
                        alertErrorWithTitle("Submission failed.", message: error!.userInfo?["error"] as? String, inViewController: self)
                    }
                }
            })
        }
        else {
            user.saveInBackgroundWithBlock { (success, error) -> Void in
                
                // For push notifications
                var currentInstallation = PFInstallation.currentInstallation()
                currentInstallation["PWDid"] = user["PWDid"]
                currentInstallation["userID"] = user.objectId
                currentInstallation.saveInBackground()
                
                if (success){
                    self.performSegueWithIdentifier("goToInstructions", sender: nil)
                }else {
                    alertErrorWithTitle("Submission failed.", message: error!.userInfo?["error"] as? String, inViewController: self)
                }
            }
        }

    }
}
