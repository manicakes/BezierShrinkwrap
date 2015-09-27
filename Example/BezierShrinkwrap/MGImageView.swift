//
//  MGImageView.swift
//  BezierImageView
//
//  Created by Mani Ghasemlou on 9/25/15.
//  Copyright © 2015 Mani Ghasemlou. All rights reserved.
//

import UIKit
import BezierShrinkwrap

class MGImageView : UIImageView {
    
    var drawView : MGDrawView!
    var lastBezier : UIBezierPath!
    var stepValue : Int!
    var marginValue : Int!
    
    func drawBezier() {
        if marginValue != nil && stepValue != nil {
            if (drawView != nil) {
                self.drawView.removeFromSuperview()
                self.setNeedsDisplay()
            }
            
            self.getBezierOutlineAsync(stepValue, margin: marginValue) { (bezier : UIBezierPath) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    self.drawView = MGDrawView(frame: self.bounds)
                    self.drawView.backgroundColor = UIColor.clearColor()
                    
                    self.addSubview(self.drawView)
                    self.lastBezier = bezier
                    self.drawView.path = bezier
                    self.drawView.fillColor = UIColor.redColor().colorWithAlphaComponent(0.3)
                }
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}