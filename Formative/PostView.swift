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
    @IBOutlet weak var postTextView: UITextView!
    
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
        postTextView.text = "In iOS 6 and later, assigning a new value to this property also replaces the value of the attributedText property with the same text, albeit without any inherent style attributes. Instead the text view styles the new string using the font, textColor, and other style-related properties of the class."
        postTextView.scrollEnabled = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    


}
