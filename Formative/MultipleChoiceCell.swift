//
//  MultipleChoiceCell.swift
//  Formative
//
//  Created by Andrew Ke on 7/28/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

// Table view cell that has a multiple choice table view inside. Used in editing dementia profile.
class MultipleChoiceCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    // Options for multiple choice
    var array: Array<String>!{
        didSet{
            tableView.reloadData()
        }
    }
    
    // The title of the cell Ex: "Eating"
    var title: String!
    
    // Corresponding parse object key ("ADLEating", "ADLTime")
    var key: String!
    
    // Ranges from -1 to 4 depending on selection. -1 means no selection
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
        
        // Make sure all the other cells are unchecked
        for i in 0..<array.count {
            if (i != indexPath.row){
                let cell2 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0))
                cell2?.selected = false
                cell2?.accessoryType = UITableViewCellAccessoryType.None
            }
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.None
    }
}
