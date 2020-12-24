//
//  KeysCell.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 16/8/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit

class KeysCell: UITableViewCell {
    
    @IBOutlet weak var deviceId: UILabel!
    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var toggle: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
