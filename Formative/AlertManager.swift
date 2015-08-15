//
//  AlertManager.swift
//  Formative
//
//  Created by Andrew Ke on 7/27/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

// Helper function to create an alert with a title and a message
func alertErrorWithTitle(title: String, #message: String?, inViewController vc: UIViewController){
    var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    vc.presentViewController(alert, animated: true, completion: nil)
}