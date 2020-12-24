//
//  ResizingTextView.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 11/7/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit

class ResizingTextView: UITextView {
    
    override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = contentSize
        intrinsicContentSize.width += (textContainerInset.left + textContainerInset.right) / 2.0
        return intrinsicContentSize
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !bounds.size.equalTo(self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
}
