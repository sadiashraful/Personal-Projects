//
//  ProductColorOptionsView.swift
//  DemoProject
//
//  Created by Mohammad Ashraful Islam Sadi on 21/11/20.
//

import UIKit

class ProductColorOptionsView: UIView {

    @IBOutlet weak var productColorLabel: UILabel!
    @IBOutlet weak var productColor1Button: UIButton!
    @IBOutlet weak var productColor2Button: UIButton!
    @IBOutlet weak var productColor3Button: UIButton!
    @IBOutlet weak var productColor4Button: UIButton!
    @IBOutlet weak var productColor5Button: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        productColor1Button.layer.borderWidth = 1
        productColor1Button.clipsToBounds = true
        productColor1Button.layer.cornerRadius = 5
        productColor1Button.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        
        productColor2Button.layer.borderWidth = 1
        productColor2Button.clipsToBounds = true
        productColor2Button.layer.cornerRadius = 5
        productColor2Button.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        
        productColor3Button.layer.borderWidth = 1
        productColor3Button.clipsToBounds = true
        productColor3Button.layer.cornerRadius = 5
        productColor3Button.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        
        productColor4Button.layer.borderWidth = 1
        productColor4Button.clipsToBounds = true
        productColor4Button.layer.cornerRadius = 5
        productColor4Button.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        
        productColor5Button.layer.borderWidth = 1
        productColor5Button.clipsToBounds = true
        productColor5Button.layer.cornerRadius = 5
        productColor5Button.layer.borderColor = UIColor(hexString: "#ECECEC").cgColor
        
    }

}
