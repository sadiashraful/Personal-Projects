//
//  ProductVariationView.swift
//  DemoProject
//
//  Created by Mohammad Ashraful Islam Sadi on 19/11/20.
//

import UIKit

class ProductVariationView: UIView {
    
    @IBOutlet weak var productVariationLabel: UILabel!
    @IBOutlet weak var productVariationColor1Button: UIButton!
    @IBOutlet weak var productVariationColor2Button: UIButton!
    @IBOutlet weak var productVariationColor3Button: UIButton!
    @IBOutlet weak var productVariationColor4Button: UIButton!
    @IBOutlet weak var productVariationColor5Button: UIButton!
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)

      
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        productVariationColor1Button.layer.borderWidth = 1
        productVariationColor1Button.layer.cornerRadius = 5
        productVariationColor1Button.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        
        productVariationColor2Button.layer.borderWidth = 1
        productVariationColor2Button.layer.cornerRadius = 5
        productVariationColor2Button.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        
        productVariationColor3Button.layer.borderWidth = 1
        productVariationColor3Button.layer.cornerRadius = 5
        productVariationColor3Button.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        
        productVariationColor4Button.layer.borderWidth = 1
        productVariationColor4Button.layer.cornerRadius = 5
        productVariationColor4Button.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        
        productVariationColor5Button.layer.borderWidth = 1
        productVariationColor5Button.layer.cornerRadius = 5
        productVariationColor5Button.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
    }
}


