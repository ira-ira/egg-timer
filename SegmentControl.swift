//
//  SegmentControl.swift
//  egg_timer
//
//  Created by infuntis on 30.07.16.
//  Copyright © 2016 gala. All rights reserved.
//

import Foundation
import UIKit


@objc protocol SegmentControlDelegate {
    @objc optional func segmentChanged()
}

class SegmentControl: UIView{
    var delegate: SegmentControlDelegate?
    var buttonTitles = [NSLocalizedString("mainPage.FromFridge", comment: ""),NSLocalizedString("mainPage.RoomTemp", comment: "")]
    var borderColor = UIColor(hex: "#52ABCE")
    var textColor = UIColor(hex: "#54504C")
    var font = UIFont(name: "Avenir Next", size: 12)
    var selectedIndex = 0{
        didSet {
            setNeedsDisplay()
        }
    }
    var enabled = true{
        didSet {
            setNeedsDisplay()
        }
    }
    var segmentButtons = [UIButton]()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.clearSubviews()
        
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 2
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.masksToBounds = true
        for (index, button) in buttonTitles.enumerated() {
            let buttonWidth = self.frame.width / CGFloat(buttonTitles.count)
            let buttonHeight = self.frame.height
            
            let newButton = UIButton(frame: CGRect(x: CGFloat(index) * buttonWidth, y: 0, width: buttonWidth, height: buttonHeight))
            newButton.setTitle(button, for: UIControlState())
            
            newButton.titleLabel?.font = self.font!
            newButton.addTarget(self, action: #selector(SegmentControl.setSelected(_:)), for: .touchUpInside)
            newButton.layer.borderWidth = 1
            newButton.layer.borderColor = self.borderColor.cgColor
            newButton.tag = index
            newButton.showsTouchWhenHighlighted = true
            if index == selectedIndex {
                newButton.setTitleColor(self.textColor, for: UIControlState())
                newButton.backgroundColor = UIColor.clear
                
            } else {
                
                
                newButton.backgroundColor = borderColor
                newButton.setTitleColor(UIColor.white, for: UIControlState())
            }
            if !enabled{
                newButton.isEnabled = false
            } else{
                newButton.isEnabled = true
            }
            
            self.addSubview(newButton)
        }
    }
    
    func setSelected(_ sender: UIButton) {
        let value = buttonTitles.index(of: sender.titleLabel!.text!)
        if value != selectedIndex{
            selectedIndex = value!
        }
        self.delegate?.segmentChanged!()
    }
}

extension UIView
{
    func clearSubviews()
    {
        for subview in self.subviews as! [UIView] {
            subview.removeFromSuperview();
        }
    }
}


extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1) {
        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1  // skip #
        
        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)
        
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
            blue:  CGFloat((rgb &     0xFF)      )/255.0,
            alpha: alpha)
    }
}
