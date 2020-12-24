//
//  ContactCell.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 7/7/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit

enum statusType: Int {
    case kStatusOnline = 1
    case kStatusOffline
    case kStatusAway
}

class ConversationCell: UITableViewCell {
    
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var onlineOrOfflineStatus: UIImageView!
    @IBOutlet weak var badge: UIButton!
    @IBOutlet weak var statusText: MLAttributedLabel!
    
    var status = 0
    var count = 0
    var accountNo = 0
    var username: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func setOnlineOrOfflineStatus() {
        switch status {
        case statusType.kStatusAway.rawValue:
                onlineOrOfflineStatus.image = UIImage(named: "away")
                imageView?.alpha = 1.0
        case statusType.kStatusOnline.rawValue:
                onlineOrOfflineStatus.image = UIImage(named: "available")
                imageView?.alpha = 1.0
        case statusType.kStatusOffline.rawValue:
                onlineOrOfflineStatus.image = UIImage(named: "offline")
                imageView?.alpha = 0.5
            default:
                break
        }
    }
    
    func showStatusText(_ text: String?) {
        if !(statusText.text == text) {
            statusText.text = text
            self.setStatusTextLayout(text)
        }
    }
    
    func showStatusTextItalic(_ text: String?, withItalicRange italicRange: NSRange) {
        let italicFont = UIFont.italicSystemFont(ofSize: statusText.font.pointSize)
        let italicString = NSMutableAttributedString(string: text ?? "")
        italicString.addAttribute(.font, value: italicFont, range: italicRange)

        if !italicString.isEqual(to: statusText.originalAttributedText()) {
            statusText.attributedText = italicString
            self.setStatusTextLayout(text)
        }
    }
    
    func setStatusTextLayout(_ text: String?) {
        if text?.isEmpty == false {
            displayName.isHidden = false
            statusText.isHidden = false
        } else {
            displayName.isHidden = true
            statusText.isHidden = true
        }
    }
    
    func setCount(_ count: Int) {
        if self.count != count {
            self.count = count
            if self.count > 0 {
                badge.isHidden = false
                badge.setTitle(String(format: "%ld", Int(self.count)), for: .normal)
            }
        } else {
            if !badge.isHidden {
                //handle initial load
                badge.isHidden = true
                badge.setTitle("", for: .normal)
            }
        }
    }

}
