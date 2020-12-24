//
//  ProductInformationView.swift
//  DemoProject
//
//  Created by Mohammad Ashraful Islam Sadi on 19/11/20.
//

import UIKit

class ProductInformationView: UIView {

    @IBOutlet weak var newPriceLabeL: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var discountPercentageLabel: UILabel!
    @IBOutlet weak var surroundingPercentageView: UIView!
    @IBOutlet weak var loveProductButton: UIButton!
    @IBOutlet weak var productShareButton: UIButton!
    
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    @IBOutlet weak var productRatingLabel: UILabel!
    @IBOutlet weak var productStarIcon: UIImageView!
    
    @IBOutlet weak var numberOfRatingsLabel: UILabel!
    @IBOutlet weak var productReviewsLabel: UILabel!
    @IBOutlet weak var productOrdersLabel: UILabel!
    
    override func awakeFromNib() {
        surroundingPercentageView.layer.cornerRadius = 10
        productStarIcon.tintColor = UIColor(hexString: "#00B55B")
    }
    
}
