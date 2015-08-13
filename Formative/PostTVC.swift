//
//  PostTVC.swift
//  Formative
//
//  Created by Andrew Ke on 7/23/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

class PostTVC: UITableViewCell {

    @IBOutlet weak var postView: PostView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        postView.layer.shadowOffset = CGSize(width: 2, height: 3)
        postView.layer.shadowRadius = 2
        postView.layer.shadowOpacity = 0.3
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
