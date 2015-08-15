//
//  DocumentViewController.swift
//  Formative
//
//  Created by Andrew Ke on 8/10/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController, UIDocumentInteractionControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = NSBundle.mainBundle().URLForResource("Legal", withExtension: "pdf")
        
        var documentInteractionController = UIDocumentInteractionController(URL: url!)
        
        documentInteractionController.delegate = self
        
        documentInteractionController.presentPreviewAnimated(true)
        // Do any additional setup after loading the view.
    }
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerDidEndPreview(controller: UIDocumentInteractionController) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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
    }
    */

}
