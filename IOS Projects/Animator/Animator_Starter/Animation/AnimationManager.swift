//
//  AnimationManager.swift
//  Animator_Starter
//
//  Created by Sadi Ashraful on 28/07/2018.
//  Copyright © 2018 Paradigm Shift Development, LLC. All rights reserved.
//

import UIKit
class AnimationManager{
    
    //Calculated screen bounds
    class var screenBounds: CGRect{
        return UIScreen.main.bounds
    }
    
    //Screen positions
    class var screenRight: CGPoint{
        return CGPoint(x: screenBounds.maxX, y: screenBounds.midY)
    }
    
    class var screenTop: CGPoint{
        return CGPoint(x: screenBounds.midX, y: screenBounds.minY)
    }
    
    class var screenLeft: CGPoint{
        return CGPoint(x: screenBounds.minX, y: screenBounds.midY)
    }
    
    class var screenBottom: CGPoint{
        return CGPoint(x: screenBounds.midX, y: screenBounds.maxY)
    }
    
    //Tracking variables
    var constraintOrigins = [CGFloat]()
    var currentConstraints: [NSLayoutConstraint]!
    
    init(activeConstraints: [NSLayoutConstraint]) {
        for constraints in activeConstraints {
            constraintOrigins.append(constraints.constant)
            constraints.constant -= AnimationManager.screenBounds.width
        }
        
        currentConstraints = activeConstraints
    }
    
    
    
    
    
    
    
    
    
}
