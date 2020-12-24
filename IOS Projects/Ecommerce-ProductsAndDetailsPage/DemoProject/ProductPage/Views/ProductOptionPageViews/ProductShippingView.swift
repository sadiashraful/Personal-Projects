//
//  ProductShippingView.swift
//  DemoProject
//
//  Created by Mohammad Ashraful Islam Sadi on 21/11/20.
//

import UIKit
import DropDown

class ProductShippingView: UIView {

    @IBOutlet weak var shippingIcon: UIImageView!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var estimatedDeliveryLabel: UILabel!
    @IBOutlet weak var selectShippingTypeButton: UIButton!
    
    var dropDownButton = DropDown()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectShippingTypeButton.layer.borderWidth = 1
        selectShippingTypeButton.layer.cornerRadius = 5
        selectShippingTypeButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        
        selectShippingTypeButton.addTarget(self,
                                              action: #selector(chooseProductShippingType),
                                              for: .touchUpInside)
        
    }
    
    @objc func chooseProductShippingType(_ sender: UIButton) {
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
