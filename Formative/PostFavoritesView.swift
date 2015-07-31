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
    
    var starred:Bool = false
    
    override var className: String {
        get {
            return "PostFavoritesView"
        }
        set {
            self.className = newValue
        }
    }
    
    // Toggle star fill
    @IBAction func tap(sender: UITapGestureRecognizer) {
        if (starred){
            starred = false
            starImage.image = UIImage(named: "Star")
        }else {
            starred = true
            starImage.image = UIImage(named: "FilledStar")
        }
    }
}
