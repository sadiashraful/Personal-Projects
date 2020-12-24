//
//  ShippingInfoCell.swift
//  DemoProject
//
//  Created by Mohammad Ashraful Islam Sadi on 19/11/20.
//

import UIKit
import DropDown

class ShippingInfoCell: UITableViewCell {
    
    @IBOutlet weak var shippingIcon: UIImageView!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var estimatedDeliveryLabel: UILabel!
    @IBOutlet weak var productShippingTypeButton: UIButton!
    
    var dropDownButton = DropDown()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        productShippingTypeButton.backgroundColor = .clear
        productShippingTypeButton.layer.borderWidth = 1
        productShippingTypeButton.layer.cornerRadius = 5
        productShippingTypeButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func chooseProductShippingType(_ sender: UIButton) {
        dropDownButton.dataSource = ["Standard Shipping", "Two Days Delivery", "One Week Delivery"]
        dropDownButton.anchorView = sender
        dropDownButton.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDownButton.show() 
        dropDownButton.selectionAction = { [weak self] (index: Int, item: String) in
          guard let _ = self else { return }
          sender.setTitle(item, for: .normal)
        }
      }
}
