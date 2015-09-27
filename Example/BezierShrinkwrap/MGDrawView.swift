//
//  MGDrawView.swift
//  BezierImageView
//
//  Created by Mani Ghasemlou on 9/25/15.
//  Copyright © 2015 Mani Ghasemlou. All rights reserved.
//

import UIKit

class MGDrawView : UIView {
    
    var path : UIBezierPath? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var fillColor : UIColor? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if let path = path {
            if let fillColor = fillColor {
                fillColor.setFill()
                path.fill()
            }
        }
    }
    
}
