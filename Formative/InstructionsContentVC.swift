//
//  InstructionsContentVC.swift
//  Formative
//
//  Created by Andrew Ke on 8/4/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

// Content VC for InstructionsContentVC
class InstructionsContentVC: UIViewController{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var mainText: UILabel!
    
    var pageData: [String]!
    var pageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = UIImage(named: pageData![0])
    }
}
