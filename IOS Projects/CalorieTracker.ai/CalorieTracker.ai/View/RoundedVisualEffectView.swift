//
//  RoundedVisualEffectView.swift
//  CalorieTracker.ai
//
//  Created by Sadi Ashraful on 06/11/2018.
//  Copyright © 2018 Sadi Ashraful. All rights reserved.
//

import UIKit

class RoundedVisualEffectView: UIVisualEffectView {

    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
        self.clipsToBounds = true
    }

}
