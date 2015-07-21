//
//  PostView.swift
//  
//
//  Created by Andrew Ke on 7/9/15.
//
//

import UIKit

@IBDesignable class PostView: UIReusableView  {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentTextBox: UITextView!
    
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonToCommentsConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonToBottomConstraint: NSLayoutConstraint!
    
    
    override var className: String {
        get {
            return "PostView"
        }
        set {
            self.className = newValue
        }
    }
    
    func setup(){
        postTextView.sizeToFit()
        textViewHeight.constant = postTextView.bounds.height-20
        
        var aspectRatioConstraint = NSLayoutConstraint(
            item: postImage,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: postImage,
            attribute: .Height,
            multiplier: postImage.image!.aspectRatio,
            constant: 0)
        postImage.addConstraint(aspectRatioConstraint)
        
        commentsTableView.hidden = true
        commentTextBox.hidden = true
        
        buttonToBottomConstraint.constant = 5
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    var commentsHidden = true
    @IBAction func revealOrHideComments(sender: UIButton) {
        if (commentsHidden)
        {
            commentsHidden = false
            
            buttonToBottomConstraint.constant = 253
            
            UIView.animateWithDuration(0.5, animations: {
                self.superview?.layoutIfNeeded()
            }, completion: { (completed) -> Void in
                self.commentsTableView.hidden = false
                self.commentTextBox.hidden = false
            })
        }
        else
        {
            commentsHidden = true
            
            self.commentsTableView.hidden = true
            self.commentTextBox.hidden = true
            
            buttonToBottomConstraint.constant = 5
            
            UIView.animateWithDuration(0.5, animations: {
                self.superview?.layoutIfNeeded()
            })
        }
        
        
    }


}

extension UIImage
{
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}
