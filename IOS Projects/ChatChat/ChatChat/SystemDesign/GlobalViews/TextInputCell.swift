//
//  TextInputCell.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 8/7/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit

class TextInputCell: UITableViewCell {
    
    @IBOutlet weak var textInput: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        textInput?.clearButtonMode = UITextField.ViewMode.unlessEditing
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
