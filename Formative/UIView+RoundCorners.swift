//
//  UIView+RoundCorners.swift
//  Formative
//
//  Created by Andrew Ke on 7/20/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            if (newValue == -1){
                layer.cornerRadius = bounds.height/2-50
            }
            self.clipsToBounds = true
        }
    }
}