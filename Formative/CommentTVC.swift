//cir
//  CommentTVC.swift
//  Formative
//
//  Created by Andrew Ke on 7/21/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit
import ParseUI

// Table view cell to display comments
class CommentTVC: UITableViewCell {
    
    var view: UIView!
    
    // Multiline UILabel
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var profileImage: CircularImageView!

}
