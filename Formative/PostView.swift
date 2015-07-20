//
//  PostView.swift
//  
//
//  Created by Andrew Ke on 7/9/15.
//
//

import UIKit

@IBDesignable class PostView: UIReusableView {

    @IBOutlet weak var postImage: UIImageView!
    
    override var className: String {
        get {
            return "PostView"
        }
        set {
            self.className = newValue
        }
    }
    
    func setup(){
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5
        //postImage.hidden = true
        var newFrame = postImage.frame
        frame.size.height = 0
        postImage.frame = newFrame
        setNeedsLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    


}
