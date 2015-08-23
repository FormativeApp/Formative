//
//  TextFieldCell.swift
//  Formative
//
//  Created by Andrew Ke on 7/28/15.
//  Copyright (c) 2015 Andrew Ke. All rights reserved.
//

import UIKit

// UITableView cell with a textfiled and a title label. 

class TextFieldCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var textField: UITextField! {
        didSet{
            textField.delegate = self
        }
    }
    
    var key: String!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
