//
//  AddPostViewController.swift
//  Formative
//
//  Created by Andrew Ke on 7/28/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import MobileCoreServices
import Parse
import Bolts

class AddPostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var photoButtonAspectRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        messageTextView.delegate = self
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        // Configure placeholder text
        if (messageTextView.text == "Add a message"){
            textView.text = ""
        }
        
        messageTextView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (messageTextView.text == ""){
            textView.text = "Add a message"
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: - Image Picker
    
    @IBAction func addPhotoButtonPressed() {
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
    
    func takePhoto()
    {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .Camera
            picker.mediaTypes = [kUTTypeImage]
            picker.delegate = self
            picker.allowsEditing = false
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
            picker.allowsEditing = false
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        photoButton.setImage(image, forState: UIControlState.Normal)
        //photoButtonAspectRatioConstraint.constant = photoButton.imageView!.image!.aspectRatio
        
        photoButton.cornerRadius = photoButton.bounds.width/2
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Parse
    
    @IBAction func post(sender: UIButton) {
        
        if (messageTextView.text == "Add a message")
        {
            alertErrorWithTitle("Please add a message body", message: nil, inViewController: self)
            return
        }
        
        if (categoryButton.titleLabel?.text == "Choose Category")
        {
            alertErrorWithTitle("Please choose a category", message: nil, inViewController: self)
            return
        }
        
        var post = PFObject(className: "Post")
        post["text"] = messageTextView.text
        post["type"] = sender.titleLabel!.text == "Post as Update" ? "Update" : "Question"
        post["stars"] = []
        post["comments"] = []
        
        if (PFUser.currentUser()!["isAdmin"] as? Bool == true)
        {
            post["recipientID"] = "admin"
            post["tags"] = "Admin Message"

        }
        else
        {
            post["recipientID"] = PFUser.currentUser()!["PWDid"]
            post["tags"] = ["\(categoryButton.titleLabel!.text!)"]

        }

        post["user"] = PFUser.currentUser()

        if (photoButton.imageView?.image != UIImage(named: "Choose Picture"))
        {
            if let image = photoButton.imageView?.image {
                let imageData = UIImagePNGRepresentation(image) //takes the image and converts it to the binary code
                if (Double(imageData.length)/1000000.0  >= 9.9)
                {
                    alertErrorWithTitle("Image size too large.", message: "Please keep image sizes below 10MB", inViewController: self)
                    return
                }
                let imageFile = PFFile(data: imageData)
                post["photo"] = imageFile
                post["aspectRatio"] = image.aspectRatio
            }
        }else{
            println("No Picture!")
        }
        
        post.saveInBackground()
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Storyboard Navigation
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        // Placeholder for unwind segue from category vc.
    }
    
    // go back to the feed vc
    @IBAction func cancel(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
