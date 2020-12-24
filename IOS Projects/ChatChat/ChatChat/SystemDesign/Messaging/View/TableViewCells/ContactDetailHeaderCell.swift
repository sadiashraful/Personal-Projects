//
//  ContactDetailHeaderCellTableViewCell.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 14/8/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit

class ContactDetailHeaderCell: UITableViewCell {
    
    @IBOutlet weak var jabberID: UILabel!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var isContact: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
