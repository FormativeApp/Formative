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
        relationPicker.selectRow(3, inComponent: 0, animated: true)
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
            PFUser.currentUser()?.setObject(imageFile, forKey: "profileImage")
            PFUser.currentUser()?.saveInBackground()
            
        }
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
        return ["Spouse", "Parent", "Grandparent", "Friend", "Neighbor", "Client", "Other"][row]
    }
    
    @IBAction func done(sender: AnyObject) {
        var user = PFUser.currentUser()!
        var nameSplit = split(nameTextField.text) {$0 == " "}
        println(nameSplit)
        
        if (nameSplit.count != 2) {
            alertErrorWithTitle("Invalid Name", message: "Please add both your first and last name.", inViewController: self)
            return
        }
        
        user["name"] = nameSplit[0]
        user["fullName"] = nameTextField.text
        user["completedSetup"] = true
        user["PWDrelation"] = ["Spouse", "Parent", "Grandparent", "Friend", "Neighbor", "Client", "Other"][relationPicker.selectedRowInComponent(0)]
        if (user["invited"] as? Bool == false)
        {
            var patient = PFObject(className: "Patient")
            patient.saveInBackgroundWithBlock({ (success, error) -> Void in
                user["PWDid"] = patient.objectId
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
                if (success){
                    self.performSegueWithIdentifier("goToInstructions", sender: nil)
                }else {
                    alertErrorWithTitle("Submission failed.", message: error!.userInfo?["error"] as? String, inViewController: self)
                }
            }
        }

    }
}
