//
//  PostTVC.swift
//  Formative
//
//  Created by Andrew Ke on 7/23/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

// Contains a post view
class PostTVC: UITableViewCell {

    @IBOutlet weak var postView: PostView!
    
    // No shadows enabled for best performance right now
    // Uncomment awakeFromNib() to enable shadows
    
    /*override func awakeFromNib() {
        super.awakeFromNib()
        
        postView.layer.shadowOffset = CGSize(width: 2, height: 3)
        postView.layer.shadowRadius = 2
        postView.layer.shadowOpacity = 0.3
        
        // Performance improvements at http://stackoverflow.com/questions/10133109/fastest-way-to-do-shadows-on-ios/10133182#10133182
        postView.layer.shouldRasterize = true
        postView.layer.rasterizationScale = UIScreen.mainScreen().scale

    }*/

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
