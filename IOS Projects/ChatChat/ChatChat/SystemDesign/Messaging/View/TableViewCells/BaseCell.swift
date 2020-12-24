//
//  BaseCell.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 11/7/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit

let kDefaultTextHeight = 20
let kDefaultTextOffset = 5

let kDelivered = "Delivered"
let kRead = "Read"

class BaseCell: UITableViewCell {
    
    var outBound: Bool = false
    var link: String?
    var deliveryFailed = false
    var messageHistoryId: NSNumber?
    
    weak var parent: UIViewController?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameHeight: NSLayoutConstraint!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var messageStatus: UILabel!
    @IBOutlet weak var dividerDate: UILabel!
    @IBOutlet weak var dividerHeight: NSLayoutConstraint!
    @IBOutlet weak var bubbleTop: NSLayoutConstraint!
    @IBOutlet weak var dayTop: NSLayoutConstraint!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var bubbleImage: UIImageView!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet var retry: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let backgrounds = UserDefaults.standard.bool(forKey: "ChatBackgrounds")
//        if backgrounds {
//            self.name.textColor = .black
//            self.date.textColor = .black
//            self.messageStatus.textColor = UIColor.black
//            self.dividerDate.textColor = UIColor.white
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(withNewSender newSender: Bool){
//        if parent?.responds(to: #selector(retry(_:))){
//            retry.addTarget(parent, action: #selector(retry(_:)), for: .touchUpInside)
//        }
        //retry.tag = Int(truncating: messageHistoryId!)
        
//        if deliveryFailed {
//            retry.isHidden = false
//        } else {
//            retry.isHidden = true
//        }

        if (name != nil) {
            if name.text?.count == 0 {
                nameHeight.constant = 0
                bubbleTop.constant = 0
                dayTop.constant = 0
            } else {
                nameHeight.constant = CGFloat(kDefaultTextHeight)
                bubbleTop.constant = CGFloat(kDefaultTextOffset)
                dayTop.constant = CGFloat(kDefaultTextOffset)
            }
        }
        
        if dividerDate.text?.count == 0 {
            dividerHeight.constant = 0
            if !(name != nil) {
                bubbleTop.constant = 0
                dayTop.constant = 0
            }
        } else {
            if self.name == nil {
                bubbleTop.constant = CGFloat(kDefaultTextOffset)
                dayTop.constant = CGFloat(kDefaultTextOffset)
            }
            dividerHeight.constant = CGFloat(kDefaultTextHeight)
        }

        if newSender && dividerHeight.constant == 0 {
            dividerHeight.constant = CGFloat(kDefaultTextHeight / 2)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.deliveryFailed = false
        self.outBound = false
    }

}
