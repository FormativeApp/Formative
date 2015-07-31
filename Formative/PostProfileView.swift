//
//  PostProfileView.swift
//  Formative
//
//  Created by Andrew Ke on 7/20/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

@IBDesignable class PostProfileView: UIReusableView {
    
    @IBOutlet weak var profileImage: CircularImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override var className: String {
        get {
            return "PostProfileView"
        }
        set {
            self.className = newValue
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
