//
//  AdminViewViewController.swift
//  Formative
//
//  Created by Jihoon Kim on 7/30/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import MobileCoreServices
import Parse
import Bolts

class AdminViewViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var controller: UISegmentedControl!
    @IBOutlet weak var sendToSelected: UIButton!
    @IBOutlet weak var sendToAll: UIButton!
    
    
    @IBOutlet weak var postQuestions: UIView!
    @IBOutlet weak var postUpdates: UIView!
    
    @IBOutlet weak var adminPostTitle: UITextField!
    @IBOutlet weak var adminPostMsg: UITextView!
    @IBOutlet weak var adminPostCategory: UIButton!
    @IBOutlet weak var adminPostChoosePhoto: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }-
    */

    @IBAction func ChangeLbl(sender: UISegmentedControl) {
        switch controller.selectedSegmentIndex {
        case 0:         // Post questions
            postQuestions.hidden = false
            postUpdates.hidden = true
        case 1:         // Post Updates
            postQuestions.hidden = true
            postUpdates.hidden = false
        default:
            break
        }
    }
    
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
        
        
        adminPostChoosePhoto.setImage(image, forState: UIControlState.Normal)
        adminPostChoosePhoto.cornerRadius = adminPostChoosePhoto.bounds.width/2
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        // Placeholder for unwind segue from category vc.
    }
}
