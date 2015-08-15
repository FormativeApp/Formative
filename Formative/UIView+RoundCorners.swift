//
//  UIView+RoundCorners.swift
//  Formative
//
//  Created by Andrew Ke on 7/20/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

// Extension to give UIView rounded corners (Editable from the IB Builder). From NSHipster
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
}