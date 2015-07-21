//
//  PostView.swift
//  
//
//  Created by Andrew Ke on 7/9/15.
//
//

import UIKit

@IBDesignable class PostView: UIReusableView, UITableViewDataSource  {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentTextBox: UITextView!
    
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
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
        
        commentsTableView.registerNib(UINib(nibName: "CommentTVC", bundle: nil), forCellReuseIdentifier: "commentCell")
        
        commentsTableView.dataSource = self
        commentsTableView.estimatedRowHeight = commentsTableView.rowHeight
        commentsTableView.rowHeight = UITableViewAutomaticDimension
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
            
            tableViewHeight.constant = commentsTableView.contentSize.height
            buttonToBottomConstraint.constant = commentTextBox.frame.height + tableViewHeight.constant + 30
            
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 4
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...

        return cell
    }



}

extension UIImage
{
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}
