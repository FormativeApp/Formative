//
//  MultipleChoiceCell.swift
//  Formative
//
//  Created by Andrew Ke on 7/28/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

class MultipleChoiceCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var array: Array<String>!{
        didSet{
            tableView.reloadData()
        }
    }
    
    var title: String!
    
    var key: String!
    
    var selection = -1
    
    override func awakeFromNib() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MultilineCell
        cell.multilineText.text = array[indexPath.row]
        cell.selected = false
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == selection){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell.setSelected(true, animated: true)
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.selected = false
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return title
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selection = indexPath.row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        for i in 0..<array.count {
            if (i != indexPath.row){
                let cell2 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0))
                cell2?.selected = false
                cell2?.accessoryType = UITableViewCellAccessoryType.None
            }
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        println("deselecting!")
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.None
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */

}
