//
//  ReviewsCell.swift
//  DemoProject
//
//  Created by Mohammad Ashraful Islam Sadi on 19/11/20.
//

import UIKit

class ReviewsCell: UITableViewCell {
    
    @IBOutlet weak var reviewsIcon: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
