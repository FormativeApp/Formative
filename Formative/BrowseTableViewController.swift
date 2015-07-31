//
//  BrowseTableViewController.swift
//  Formative
//
//  Created by Andrew Ke on 7/27/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

class BrowseTableViewController: UITableViewController {

    var browserContent: NSArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var browerContentData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("browser", ofType: "json")!)
        browserContent = parseJSON(browerContentData!) as! NSArray
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        //println(browserContent)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //#warning Incomplete method implementation.
        // Return the number of rows in the section.
        return browserContent.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath) as! BrowsePhotoCell
        
        let category = browserContent[indexPath.row] as! NSDictionary
        
        cell.categoryLabel.text = category["title"] as? String
        cell.backgroundImage.image = UIImage(named: category["title"] as! String + ".png")
        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        var keywordsVC = segue.destinationViewController as! KeywordsTVC
        var row = tableView.indexPathForSelectedRow()?.row
        let category = browserContent[row!] as! NSDictionary
        keywordsVC.keywordsArray = category["keywords"] as! NSArray
        
        keywordsVC.title = category["title"] as? String
        
    }

}
