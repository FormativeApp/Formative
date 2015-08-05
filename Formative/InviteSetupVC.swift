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

class InviteSetupVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var profileImage: CircularImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    
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
        
        user.saveInBackgroundWithBlock { (success, error) -> Void in
            if (success){
                user["completedSetup"] = true
                self.performSegueWithIdentifier("goToInvite", sender: nil)
            }else {
                alertErrorWithTitle("Submission failed.", message: error!.userInfo?["error"] as? String, inViewController: self)
            }
        }
    }
}
