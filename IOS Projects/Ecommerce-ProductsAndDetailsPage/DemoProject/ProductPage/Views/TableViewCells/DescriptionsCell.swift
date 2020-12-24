//
//  DescriptionsCell.swift
//  DemoProject
//
//  Created by Mohammad Ashraful Islam Sadi on 19/11/20.
//

import UIKit

class DescriptionsCell: UITableViewCell {
    
    @IBOutlet weak var descriptionsIcon: UIImageView!
    @IBOutlet weak var descriptionsLabel: UILabel!
    @IBOutlet weak var menImageOne: UIImageView!
    @IBOutlet weak var menImageTwo: UIImageView!
    @IBOutlet weak var menImageThree: UIImageView!
    @IBOutlet weak var viewFullDescriptionLabeL: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
