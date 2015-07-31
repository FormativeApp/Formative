//
//  CircularImageView.swift
//  Formative
//
//  Created by Andrew Ke on 7/20/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import Bolts

@IBDesignable class CircularImageView: PFImageView {
    
    override var bounds:CGRect {
        didSet{
            setup()
        }
    }
    
    func setup() {
        cornerRadius = bounds.height/2
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }

}
