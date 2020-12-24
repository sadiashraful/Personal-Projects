//
//  ProductOptionPageView.swift
//  DemoProject
//
//  Created by Mohammad Ashraful Islam Sadi on 20/11/20.
//

import UIKit

class SlideUpView: UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var  titleLabel: UILabel!
    @IBOutlet weak var productCoverImage: UIImageView!
    @IBOutlet weak var nextImageButton: UIButton!
    @IBOutlet weak var previousImageButton: UIButton!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var productColorOptionsView: ProductColorOptionsView!
    @IBOutlet weak var productSizeAndQuantityView: ProductSizeAndQuantityView!
    @IBOutlet weak var productShippingView: ProductShippingView!
    
    var globalTag = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        
        self.layer.cornerRadius = 15
        previousImageButton.isHidden = true
        productCoverImage.layer.cornerRadius = 15
        productCoverImage.layer.masksToBounds = false
        productCoverImage.clipsToBounds = true
        
        nextImageButton.layer.cornerRadius = 0.5 * nextImageButton.bounds.size.width
        previousImageButton.layer.cornerRadius = 0.5 * previousImageButton.bounds.size.width
        
        previousImageButton.addTarget(self, action: #selector(handlePreviousImageButtonPressed), for: .touchUpInside)
        nextImageButton.addTarget(self, action: #selector(handleNextImageButtonPressed), for: .touchUpInside)
        
        productColorOptionsView.productColor1Button.addTarget(self, action: #selector(color1ButtonPressed), for: .touchUpInside)
        productColorOptionsView.productColor2Button.addTarget(self, action: #selector(color2ButtonPressed), for: .touchUpInside)
        productColorOptionsView.productColor3Button.addTarget(self, action: #selector(color3ButtonPressed), for: .touchUpInside)
        productColorOptionsView.productColor4Button.addTarget(self, action: #selector(color4ButtonPressed), for: .touchUpInside)
        productColorOptionsView.productColor5Button.addTarget(self, action: #selector(color5ButtonPressed), for: .touchUpInside)
        
    }
    
    @objc func color1ButtonPressed(){
        
        UIView.transition(with: productCoverImage,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.productColorOptionsView.productColor1Button.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
                            self.productColorOptionsView.productColor1Button.layer.borderWidth = 2
                            self.productCoverImage.image = self.productColorOptionsView.productColor1Button.currentImage
                            
                            self.productColorOptionsView.productColor2Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor2Button.layer.borderWidth = 1
                            
                            self.productColorOptionsView.productColor3Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor3Button.layer.borderWidth = 1
                            
                            self.productColorOptionsView.productColor4Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor4Button.layer.borderWidth = 1
                            
                            self.productColorOptionsView.productColor5Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor5Button.layer.borderWidth = 1
                            
                            self.nextImageButton.isHidden = false
                            self.previousImageButton.isHidden = true
                          },
                          completion: nil)
        
    }
    
    @objc func color2ButtonPressed(){
        
        
        UIView.transition(with: productCoverImage,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.productColorOptionsView.productColor2Button.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
                            self.productColorOptionsView.productColor2Button.layer.borderWidth = 2
                            
                            self.productCoverImage.image = self.productColorOptionsView.productColor2Button.currentImage
                            
                            self.productColorOptionsView.productColor1Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor1Button.layer.borderWidth = 1
                            
                            self.productColorOptionsView.productColor3Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor3Button.layer.borderWidth = 1
                            
                            self.productColorOptionsView.productColor4Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor4Button.layer.borderWidth = 1
                            
                            self.productColorOptionsView.productColor5Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor5Button.layer.borderWidth = 1
                            
                            self.nextImageButton.isHidden = false
                            self.previousImageButton.isHidden = false
                          },
                          completion: nil)
    }
    
    @objc func color3ButtonPressed(){
        
        UIView.transition(with: productCoverImage,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.productColorOptionsView.productColor3Button.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
                            self.productColorOptionsView.productColor3Button.layer.borderWidth = 2
                            self.productCoverImage.image = self.productColorOptionsView.productColor3Button.currentImage
                            
                            self.productColorOptionsView.productColor1Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor1Button.layer.borderWidth = 1
                            
                            self.productColorOptionsView.productColor2Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor2Button.layer.borderWidth = 1
                            
                            self.productColorOptionsView.productColor4Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor4Button.layer.borderWidth = 1
                            
                            self.productColorOptionsView.productColor5Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor5Button.layer.borderWidth = 1
                            
                            self.nextImageButton.isHidden = false
                            self.previousImageButton.isHidden = false
                          },
                          completion: nil)
        
        
    }
    
    @objc func color4ButtonPressed(){
        
        UIView.transition(with: productCoverImage,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.productColorOptionsView.productColor4Button.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
                            self.productColorOptionsView.productColor4Button.layer.borderWidth = 2
                            self.productCoverImage.image = self.productColorOptionsView.productColor4Button.currentImage
                            
                            self.productColorOptionsView.productColor1Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor1Button.layer.borderWidth = 1
                            
                            self.productColorOptionsView.productColor2Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor2Button.layer.borderWidth = 1
                            
                            self.productColorOptionsView.productColor3Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor3Button.layer.borderWidth = 1
                            
                            self.productColorOptionsView.productColor5Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor5Button.layer.borderWidth = 1
                            
                            self.nextImageButton.isHidden = false
                            self.previousImageButton.isHidden = false
                            
                          },
                          completion: nil)
        
        
        
        
    }
    
    @objc func color5ButtonPressed(){
        
        UIView.transition(with: productCoverImage,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.productColorOptionsView.productColor5Button.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
                            self.productColorOptionsView.productColor5Button.layer.borderWidth = 2
                            self.productCoverImage.image = self.productColorOptionsView.productColor5Button.currentImage
                            
                            self.productColorOptionsView.productColor1Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor1Button.layer.borderWidth = 1
                            
                            self.productColorOptionsView.productColor2Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor2Button.layer.borderWidth = 1
                            
                            self.productColorOptionsView.productColor3Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor3Button.layer.borderWidth = 1
                            
                            self.productColorOptionsView.productColor4Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                            self.productColorOptionsView.productColor4Button.layer.borderWidth = 1
                            
                            self.nextImageButton.isHidden = true
                            self.previousImageButton.isHidden = false
                          },
                          completion: nil)
        
        
        
    }
    
    
    @objc func handlePreviousImageButtonPressed(byUser sender: UIButton){
        
        print("sendertag = \(sender.tag)")

        sender.tag += 1
        if sender.tag > 4 { sender.tag = 1}
        
        switch sender.tag {
        case 1:
            UIView.transition(with: productCoverImage,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                    
                                
                                self.productCoverImage.image = self.productColorOptionsView.productColor4Button.currentImage
                                self.productColorOptionsView.productColor4Button.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
                                self.productColorOptionsView.productColor4Button.layer.borderWidth = 2
                                
                                self.productColorOptionsView.productColor1Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor1Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor2Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor2Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor3Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor3Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor5Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor5Button.layer.borderWidth = 1
                                
                                self.previousImageButton.isHidden = false
                                self.nextImageButton.isHidden = false
                              },
                              completion: nil)
            
            
            
        case 2:
            UIView.transition(with: productCoverImage,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.productCoverImage.image = self.productColorOptionsView.productColor3Button.currentImage
                                self.productColorOptionsView.productColor3Button.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
                                self.productColorOptionsView.productColor3Button.layer.borderWidth = 2
                                
                                self.productColorOptionsView.productColor1Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor1Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor2Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor2Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor4Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor4Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor5Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor5Button.layer.borderWidth = 1
                                self.previousImageButton.isHidden = false
                              },
                              completion: nil)
            
        case 3:
            UIView.transition(with: productCoverImage,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
       
                                
                                self.productCoverImage.image = self.productColorOptionsView.productColor2Button.currentImage
                                self.productColorOptionsView.productColor2Button.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
                                self.productColorOptionsView.productColor2Button.layer.borderWidth = 2
                                
                                self.productColorOptionsView.productColor1Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor1Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor3Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor3Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor4Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor4Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor5Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor5Button.layer.borderWidth = 1
                                self.previousImageButton.isHidden = false
                              },
                              completion: nil)
            
            
        case 4:
            UIView.transition(with: productCoverImage,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                //                                    self.productCoverImage.image = self.productColorOptionsView.productColor5Button.currentImage
  
                                
                                self.productCoverImage.image = self.productColorOptionsView.productColor1Button.currentImage
                                self.productColorOptionsView.productColor1Button.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
                                self.productColorOptionsView.productColor1Button.layer.borderWidth = 2
                                
                                self.productColorOptionsView.productColor2Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor2Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor3Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor3Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor4Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor4Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor5Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor5Button.layer.borderWidth = 1
                                
                                self.previousImageButton.isHidden = true
                              },
                              completion: nil)
            
        default:
            UIView.transition(with: productCoverImage,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
    
                                self.productCoverImage.image = self.productColorOptionsView.productColor5Button.currentImage
                                self.productColorOptionsView.productColor5Button.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
                                self.productColorOptionsView.productColor5Button.layer.borderWidth = 2
                                
                                self.productColorOptionsView.productColor1Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor1Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor2Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor2Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor3Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor3Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor4Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor4Button.layer.borderWidth = 1
                                
                                self.nextImageButton.isHidden = false
                                self.previousImageButton.isHidden = false
                              },
                              completion: nil)
        }
        
        
        
    }
    
    @objc func handleNextImageButtonPressed(byUser sender: UIButton){
        print("sendertag in nextbutton: \(sender.tag)")
        sender.tag += 1
        if sender.tag > 4 { sender.tag = 1}
        
        switch sender.tag {
        case 1:
            UIView.transition(with: productCoverImage,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.productCoverImage.image = self.productColorOptionsView.productColor2Button.currentImage
                                self.productColorOptionsView.productColor2Button.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
                                self.productColorOptionsView.productColor2Button.layer.borderWidth = 2
                                
                                self.productColorOptionsView.productColor1Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor1Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor3Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor3Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor4Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor4Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor5Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor5Button.layer.borderWidth = 1
                                self.previousImageButton.isHidden = false
                                self.nextImageButton.isHidden = false
                              },
                              completion: nil)
        case 2:
            UIView.transition(with: productCoverImage,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.productCoverImage.image = self.productColorOptionsView.productColor3Button.currentImage
                                self.productColorOptionsView.productColor3Button.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
                                self.productColorOptionsView.productColor3Button.layer.borderWidth = 2
                                
                                self.productColorOptionsView.productColor1Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor1Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor2Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor2Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor4Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor4Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor5Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor5Button.layer.borderWidth = 1
                                self.previousImageButton.isHidden = false
                                self.nextImageButton.isHidden = false
                              },
                              completion: nil)
        case 3:
            UIView.transition(with: productCoverImage,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.productCoverImage.image = self.productColorOptionsView.productColor4Button.currentImage
                                self.productColorOptionsView.productColor4Button.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
                                self.productColorOptionsView.productColor4Button.layer.borderWidth = 2
                                
                                self.productColorOptionsView.productColor1Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor1Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor2Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor2Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor3Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor3Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor5Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor5Button.layer.borderWidth = 1
                                
                                self.nextImageButton.isHidden = false
                                self.previousImageButton.isHidden = false
                              },
                              completion: nil)
        case 4:
            UIView.transition(with: productCoverImage,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.productCoverImage.image = self.productColorOptionsView.productColor5Button.currentImage
                                self.productColorOptionsView.productColor5Button.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
                                self.productColorOptionsView.productColor5Button.layer.borderWidth = 2
                                
                                self.productColorOptionsView.productColor1Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor1Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor2Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor2Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor3Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor3Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor4Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor4Button.layer.borderWidth = 1
                                
                                self.nextImageButton.isHidden = true
                                self.previousImageButton.isHidden = false
                              },
                              completion: nil)
        default:
            UIView.transition(with: productCoverImage,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.productCoverImage.image = self.productColorOptionsView.productColor1Button.currentImage
                                self.productColorOptionsView.productColor1Button.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
                                self.productColorOptionsView.productColor1Button.layer.borderWidth = 2
                                
                                self.productColorOptionsView.productColor2Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor2Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor3Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor3Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor4Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor4Button.layer.borderWidth = 1
                                
                                self.productColorOptionsView.productColor5Button.layer.borderColor = UIColor(hexString: "#E8E8E8").cgColor
                                self.productColorOptionsView.productColor5Button.layer.borderWidth = 1
                                
                                self.nextImageButton.isHidden = false
                                self.previousImageButton.isHidden = true
                              },
                              completion: nil)
        }
        
        
        
        
    }
}
