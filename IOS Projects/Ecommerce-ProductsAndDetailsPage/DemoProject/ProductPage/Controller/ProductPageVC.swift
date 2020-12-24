//
//  ViewController.swift
//  DemoProject
//
//  Created by Mohammad Ashraful Islam Sadi on 17/11/20.
//

import UIKit

class ProductPageVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productCoverView: UIImageView!
    @IBOutlet weak var productInformationView: ProductInformationView!
    @IBOutlet weak var productVariantView: ProductVariationView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var bottonButtonLayerView: BottonButtonLayerView!
    @IBOutlet weak var slideUpView: SlideUpView!
    
    var transparentView = UIView()
    let height: CGFloat = 816
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        tableview.backgroundColor = .white
        productCoverView.anchor(top: containerView.topAnchor)
        
        slideUpView.productColorOptionsView.productColor1Button.layer.borderColor = UIColor(hexString: "#00B55B").cgColor
        slideUpView.productColorOptionsView.productColor1Button.layer.borderWidth = 2
        slideUpView.alpha = 0
        
        productVariantView.productVariationColor1Button.addTarget(self, action: #selector(handleSlideUpProductOptionPage), for: .touchUpInside)
        productVariantView.productVariationColor2Button.addTarget(self, action: #selector(handleSlideUpProductOptionPage), for: .touchUpInside)
        productVariantView.productVariationColor3Button.addTarget(self, action: #selector(handleSlideUpProductOptionPage), for: .touchUpInside)
        productVariantView.productVariationColor4Button.addTarget(self, action: #selector(handleSlideUpProductOptionPage), for: .touchUpInside)
        productVariantView.productVariationColor5Button.addTarget(self, action: #selector(handleSlideUpProductOptionPage), for: .touchUpInside)
        
        slideUpView.closeButton.addTarget(self, action: #selector(closeProductOptionPage), for: .touchUpInside)
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        scrollView.delegate = self
        
        setupCustomNavigationBar()
        
    }
    
     func setupCustomNavigationBar(){
        let backButton: UIButton = {
            let button = UIButton()
            //button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            button.setImage(#imageLiteral(resourceName: "ArrowLeftIcon"), for: .normal)
            return button
        }()
        
        let searchButton: UIButton = {
            let button = UIButton()
            //button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            button.backgroundColor = .clear
            button.setImage(#imageLiteral(resourceName: "SearchIcon"), for: .normal)
            return button
        }()
        
        let moreButton: UIButton = {
            let button = UIButton()
            //button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            button.backgroundColor = .clear
            button.setImage(#imageLiteral(resourceName: "moreVertical"), for: .normal)
            button.tintColor = .white
            return button
        }()
        
        let searchAndMoreContainerView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            return view
        }()
        
        let lineView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        backButton.setDimensions(height: 60, width: 60)
        backButton.layer.cornerRadius = 15
        
        searchButton.setDimensions(height: 30, width: 30)
        moreButton.setDimensions(height: 30, width: 30)
        lineView.setDimensions(height: 30, width: 0.5)
        
        searchAndMoreContainerView.setDimensions(height: 60, width: 90)
        searchAndMoreContainerView.layer.cornerRadius = 15
        
        searchAndMoreContainerView.addSubview(searchButton)
        searchAndMoreContainerView.addSubview(moreButton)
        searchButton.addSubview(lineView)
        
        searchButton.anchor(left: searchAndMoreContainerView.leftAnchor,
                            paddingLeft: 7.375)
        searchButton.centerY(inView: searchAndMoreContainerView)
        
        lineView.anchor(left: searchButton.rightAnchor,
                        paddingLeft: 7.375)
        lineView.centerY(inView: searchAndMoreContainerView)
        
        moreButton.anchor(right: searchAndMoreContainerView.rightAnchor,
                          paddingRight: -7.375)
        moreButton.centerY(inView: searchAndMoreContainerView)
        
        let rightBarButtonItem = UIBarButtonItem(customView: searchAndMoreContainerView)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        if (scrollView.contentOffset.y > 315) {
            self.navigationController?.navigationBar.backgroundColor = UIColor.white
            //self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.layer.borderColor = UIColor.systemGray.cgColor
            self.navigationController?.navigationItem.leftBarButtonItem?.customView?.backgroundColor = .clear
        } else {
            self.navigationController?.navigationBar.backgroundColor = UIColor.clear
            
        }
    }
    
    
    @objc func handleSlideUpProductOptionPage(){
        
        let screenSize = UIScreen.main.bounds.size
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = self.view.frame
        
        window?.addSubview(transparentView)
        
        slideUpView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: height)
        window?.addSubview(slideUpView)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.75
            self.slideUpView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)
            self.slideUpView.alpha = 1
            
        }, completion: nil)
    }
    
    @objc func closeProductOptionPage(){
        let screenSize = UIScreen.main.bounds.size
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.slideUpView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
        }, completion: nil)
    }
    
}


extension ProductPageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        cell.textLabel?.textColor = UIColor(hexString: "#515151")
        
        switch indexPath.row {
        case 0:
            let shippingInfoCell = tableView.dequeueReusableCell(withIdentifier: "ShippingInfoCell") as? ShippingInfoCell
            cell = shippingInfoCell!
            
            break
        case 1:
            let specificationCell = tableView.dequeueReusableCell(withIdentifier: "SpecificationsCell") as? SpecificationsCell
            cell = specificationCell!
            break
        case 2:
            let reviewsCell = tableView.dequeueReusableCell(withIdentifier: "ReviewsCell") as? ReviewsCell
            cell = reviewsCell!
            break
        case 3:
            let howToOrderCell = tableView.dequeueReusableCell(withIdentifier: "HowToOrderCell") as? HowToOrderCell
            cell = howToOrderCell!
            break
        case 4:
            let faqCell = tableView.dequeueReusableCell(withIdentifier: "FAQCell") as? FAQCell
            cell = faqCell!
            break
        case 5:
            let wholesaleInquiryCell = tableView.dequeueReusableCell(withIdentifier: "WholesaleInquiryCell") as? WholesaleInquiryCell
            cell = wholesaleInquiryCell!
            break
        case 6:
            let descriptionsCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionsCell") as? DescriptionsCell
            cell = descriptionsCell!
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight = 0
        
        switch indexPath.row {
        case 0:
            rowHeight = 96
            break
        case 1:
            rowHeight = 45
            break
        case 2:
            rowHeight = 45
            break
        case 3:
            rowHeight = 45
            break
        case 4:
            rowHeight = 45
            break
        case 5:
            rowHeight = 45
            break
        case 6:
            rowHeight = 705
            break
            
        default:
            break
        }
        
        
        return CGFloat(rowHeight)
    }
    
    
}

