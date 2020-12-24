//
//  ChatInputContainer.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 11/7/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit

class ChatInputContainer: UIView {

    @IBOutlet weak var chatInput: ResizingTextView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        autoresizingMask = .flexibleHeight
//        chatInput.isScrollEnabled = false
//        chatInput.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }

    override var intrinsicContentSize: CGSize { 
        let size = CGSize(width: bounds.size.width,
                           height: chatInput.intrinsicContentSize.height)
        return size
    }
}
