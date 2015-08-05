//
//  PostFavoritesView.swift
//  Formative
//
//  Created by Andrew Ke on 7/20/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

@IBDesignable class PostFavoritesView: UIReusableView {
    
    
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    var starred:Bool = false {
        didSet{
            if (starred){
                starImage.image = UIImage(named: "FilledStar")
            }else {
                starImage.image = UIImage(named: "Star")
            }
        }
    }
    
    override var className: String {
        get {
            return "PostFavoritesView"
        }
        set {
            self.className = newValue
        }
    }
}
