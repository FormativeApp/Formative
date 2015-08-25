//
//  DocumentWebViewController.swift
//  Formative
//
//  Created by Andrew Ke on 8/22/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

class DocumentWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.formative.care/terms-of-service")!))
    }
}
