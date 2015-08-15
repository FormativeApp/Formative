//
//  SettingsTableViewController.swift
//  Formative
//
//  Created by Andrew Ke on 8/11/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UIDocumentInteractionControllerDelegate {
    
    var documentInteractionController: UIDocumentInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = NSBundle.mainBundle().URLForResource("Legal", withExtension: "pdf")
        
        documentInteractionController = UIDocumentInteractionController(URL: url!)
        
        documentInteractionController!.delegate = self
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 3)
        {
            documentInteractionController!.presentPreviewAnimated(true)
        }
    }
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
