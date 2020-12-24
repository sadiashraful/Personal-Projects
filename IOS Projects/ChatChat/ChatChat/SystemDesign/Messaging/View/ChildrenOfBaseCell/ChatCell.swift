//
//  ChatCell.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 11/7/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit

class ChatCell: BaseCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func updateCell(withNewSender newSender: Bool) {
        super.updateCell(withNewSender: newSender)
        if outBound {
            textLabel?.textColor = .white
            bubbleImage.image = MLImageManager.sharedInstance().outboundImage
        } else {
            textLabel?.textColor = .black
            bubbleImage.image = MLImageManager.sharedInstance().inboundImage
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(openLink(_:)){
            if (link != nil) {
                return true
            }
        }
        return action == #selector(copy(_:))
    }
    
    @objc func openLink(_ sender: Any?){
        if (link != nil) {
            let url = URL(string: link!)
            if (url?.scheme == "http") || (url?.scheme == "https") {
                //var safariView: SFSafariViewController? = nil
//                if let url = url {
//                    safariView = SFSafariViewController(url: url)
//                }
//                if let safariView = safariView {
//                    parent.present(safariView, animated: true)
//                }
            }
        }
    }
    
    override func copy(_ sender: Any?){
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = messageBody?.text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageBody?.text = ""
    }

}
