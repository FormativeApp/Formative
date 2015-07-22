//
//  CommentTVC.swift
//  Formative
//
//  Created by Andrew Ke on 7/21/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

class CommentTVC: UITableViewCell {
    
    var view: UIView!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //textView.sizeToFit()
        //textViewHeightConstraint.constant = textView.bounds.height-20
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
