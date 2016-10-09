//
//  RoundTimer.swift
//  egg timer
//
//  Created by infuntis on 09.10.16.
//  Copyright © 2016 gala. All rights reserved.
//

import Foundation
import UIKit

let π:CGFloat = CGFloat(M_PI)

@IBDesignable class RoundTimer : UIView{
    
    @IBInspectable var counterColor: UIColor = UIColor.blue
    @IBInspectable var outlineColor: UIColor = UIColor.blue
    var arcWidth: CGFloat = 27.0
    var maxValue:Int = 10
    var counter: Int = 0 {
        didSet {
            if counter <=  maxValue {
                setNeedsDisplay()
            }
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let circlePath = UIBezierPath(ovalIn: CGRect(x: 3.75,  y: 3.75, width: bounds.width-7.5, height: bounds.width-7.5))
        
        counterColor.setFill()
        
        circlePath.fill()
        
        let startAngle: CGFloat = π / 2
        let endAngle: CGFloat = π / 2
        let angleDifference: CGFloat = 2 * π - startAngle + endAngle
        ///////////////////////////////////////////////////////////////////////////////////////////////////////
        let centerBig = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        let arcLengthPerGlassBig = angleDifference / CGFloat(maxValue)
        
        let outlineEndAngleBig = arcLengthPerGlassBig * CGFloat(counter) + startAngle
        
        let outlinePathBig = UIBezierPath(arcCenter: centerBig,
                                          radius: bounds.width - 7.5,
                                          startAngle: startAngle,
                                          endAngle: outlineEndAngleBig,
                                          clockwise: true)
        
        outlineColor.setStroke()
        outlinePathBig.lineWidth = 15.0
        outlinePathBig.stroke()
    }
}

