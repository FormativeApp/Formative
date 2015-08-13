//
//  CategorySelectionViewController.swift
//  Formative
//
//  Created by Andrew Ke on 7/30/15
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

class CategorySelectionViewController: UITableViewController {

    var categories: Array<String> = ["Sleep", "Personal Care", "Difficult Behaviors", "Communication", "Legal Decisions", "Respite Care", "Long-Term Care Providers", "Moments of Joy", "Other"]
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = categories[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("back", sender: tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var dvc = segue.destinationViewController as! AddPostViewController
        dvc.categoryButton.setTitle(sender as? String, forState: UIControlState.Normal)
    }

}
