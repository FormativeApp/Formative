//
//  InstructionsContentVC.swift
//  Formative
//
//  Created by Andrew Ke on 8/4/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

class InstructionsContentVC: UIViewController{

    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var bakcgroundImageView: UIImageView!
    
    var pageIndex: Int!
    var titleText: String!
    var imageFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepsLabel.text = titleText
    }
}
