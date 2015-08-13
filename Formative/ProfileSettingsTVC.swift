//
//  ProfileSettingsTVC.swift
//  Formative
//
//  Created by Andrew Ke on 8/4/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import MobileCoreServices
import Parse

class ProfileSettingsTVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImage: CircularImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        profileImage.file = PFUser.currentUser()!["profileImage"] as? PFFile
        profileImage.loadInBackground()
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        var loginVC = storyboard?.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
        presentViewController(loginVC, animated: true, completion: nil)
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0) {
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
            let imageData = UIImagePNGRepresentation(imageWithImage(image!, scaledToSize: CGSize(width: 200, height: 200))) //takes the image and converts it to the binary code
            let imageFile = PFFile(data: imageData)
            spinner.startAnimating()
            PFUser.currentUser()!["profileImage"] = imageFile
            PFUser.currentUser()?.saveInBackgroundWithBlock({ (success, error) -> Void in
                self.spinner.stopAnimating()
                if (success){
                    self.profileImage.image = image
                }
                else {
                    alertErrorWithTitle("Image Save Failed", message: nil, inViewController: self)
                }
            })
            
        }
        profileImage.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
