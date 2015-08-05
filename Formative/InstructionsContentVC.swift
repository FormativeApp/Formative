//
//  InstructionsContentVC.swift
//  Formative
//
//  Created by Andrew Ke on 8/4/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

class InstructionsContentVC: UIViewController{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var mainText: UILabel!
    
    var pageIndex: Int!
    var pageData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = pageData[0]
        titleLabel.alpha = 0
        backgroundImageView.image = UIImage(named: "Mealtimes")
        mainText.text = pageData[1]
        mainText.alpha = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        UIView.animateWithDuration(1.5, animations: {
            self.titleLabel.alpha = 1
            self.mainText.alpha = 1
        })
    }
}
