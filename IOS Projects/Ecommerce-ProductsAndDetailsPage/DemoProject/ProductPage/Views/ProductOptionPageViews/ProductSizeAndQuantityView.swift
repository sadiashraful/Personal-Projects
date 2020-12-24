//
//  ProductSizeAndQuantityView.swift
//  DemoProject
//
//  Created by Mohammad Ashraful Islam Sadi on 21/11/20.
//

import UIKit

class ProductSizeAndQuantityView: UIView {

    @IBOutlet weak var productSizeLabel: UILabel!
    @IBOutlet weak var productSizeSmallButton: UIButton!
    @IBOutlet weak var productSizeMediumButton: UIButton!
    @IBOutlet weak var productSizeXButton: UIButton!
    @IBOutlet weak var productSizeXLButton: UIButton!
    
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var decreaseQuantityButton: UIButton!
    @IBOutlet weak var productQuantityCountLabel: UILabel!
    @IBOutlet weak var increaseQuantityButton: UIButton!
    
    var productQuantityCount = 1
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        productSizeSmallButton.layer.borderWidth = 1
        productSizeSmallButton.layer.cornerRadius = 5
        productSizeSmallButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        
        productSizeMediumButton.layer.borderWidth = 1
        productSizeMediumButton.layer.cornerRadius = 5
        productSizeMediumButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        
        productSizeXButton.layer.borderWidth = 1
        productSizeXButton.layer.cornerRadius = 5
        productSizeXButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        
        productSizeXLButton.layer.borderWidth = 1
        productSizeXLButton.layer.cornerRadius = 5
        productSizeXLButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        
        increaseQuantityButton.layer.cornerRadius = 0.5 * increaseQuantityButton.bounds.size.width
        increaseQuantityButton.addTarget(self, action: #selector(handleIncreaseQuantityPressed), for: .touchUpInside)
        
        decreaseQuantityButton.layer.cornerRadius = 0.5 * decreaseQuantityButton.bounds.size.width
        decreaseQuantityButton.addTarget(self, action: #selector(handleDecreaseQuantityPressed), for: .touchUpInside)
        
        productSizeSmallButton.addTarget(self, action: #selector(handleProductSizeSmallButtonPressed), for: .touchUpInside)
        productSizeMediumButton.addTarget(self, action: #selector(handleProductMediumSmallButtonPressed), for: .touchUpInside)
        productSizeXButton.addTarget(self, action: #selector(handleProductSizeXButtonPressed), for: .touchUpInside)
        productSizeXLButton.addTarget(self, action: #selector(handleProductSizeXLButtonPressed), for: .touchUpInside)
        
    }
    
    @objc func handleProductSizeSmallButtonPressed(){
        productSizeSmallButton.layer.borderWidth = 2
        productSizeSmallButton.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
        
        productSizeMediumButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        productSizeMediumButton.layer.borderWidth = 1
        
        productSizeXButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        productSizeXButton.layer.borderWidth = 1
        
        productSizeXLButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        productSizeXLButton.layer.borderWidth = 1
    }
    
    @objc func handleProductMediumSmallButtonPressed(){
        productSizeMediumButton.layer.borderWidth = 2
        productSizeMediumButton.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
        
        productSizeSmallButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        productSizeSmallButton.layer.borderWidth = 1
        
        productSizeXButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        productSizeXButton.layer.borderWidth = 1
        
        productSizeXLButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        productSizeXLButton.layer.borderWidth = 1
        
    }
    
    @objc func handleProductSizeXButtonPressed(){
        productSizeXButton.layer.borderWidth = 2
        productSizeXButton.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
        
        productSizeMediumButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        productSizeMediumButton.layer.borderWidth = 1
        
        productSizeSmallButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        productSizeSmallButton.layer.borderWidth = 1
        
        productSizeXLButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        productSizeXLButton.layer.borderWidth = 1
    }
    
    @objc func handleProductSizeXLButtonPressed(){
        productSizeXLButton.layer.borderWidth = 2
        productSizeXLButton.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
        
        productSizeMediumButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        productSizeMediumButton.layer.borderWidth = 1
        
        productSizeXButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        productSizeXButton.layer.borderWidth = 1
        
        productSizeSmallButton.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        productSizeSmallButton.layer.borderWidth = 1
    }
    
    @objc func handleIncreaseQuantityPressed(){
        
    }
    
    @objc func handleDecreaseQuantityPressed(){
        
    }
}
