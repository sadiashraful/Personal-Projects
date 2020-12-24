//
//  Extensions.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 16/6/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import Foundation
import UIKit



extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil){
        
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left{
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                   paddingLeft: CGFloat = 0, constant: CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        //layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        
        
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
}

extension UIButton {
    func pulsate(){
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.5
        pulse.fromValue = 0.7
        pulse.toValue = 1.0
        pulse.autoreverses = true
//        pulse.repeatCount = 1
        pulse.initialVelocity = 10
        pulse.damping = 0.4
        layer.add(pulse, forKey: nil)
    }
}

extension Array{
    func enumerateObject(_ block : (Any, Int,inout Bool)-> Void){
        var stop = false
        for (index, aValue) in self.enumerated(){
            block(aValue,index,&stop);
        }
    }
}

//extension String {
//    /// :r: Must correctly select proper UTF-16 code-unit range. Wrong range will produce wrong result.
//    public func convertRangeFromNSRange(r:NSRange) -> Range<String.Index> {
//        let a   =   (self as NSString).substring(to: r.location)
//        let b   =   (self as NSString).substring(with: r)
//
//        let n1  =   distance(from: a.startIndex, to: a.endIndex)
//        let n2  =   distance(from: b.startIndex, to: b.endIndex)
//
//        let i1  =   index(startIndex, offsetBy: n1)
//        let i2  =   index(i1, offsetBy: n2)
//
//        return  Range<String.Index>(start: i1, end: i2)
//    }
//}

