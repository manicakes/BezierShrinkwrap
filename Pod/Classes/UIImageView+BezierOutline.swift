//
//  UIImageView+BezierOutline.swift
//  BezierImageView
//
//  Created by Mani Ghasemlou on 9/25/15.
//  Copyright © 2015 Mani Ghasemlou. All rights reserved.
//

import UIKit

public extension UIImageView {
    
    func imageForView() -> UIImage {
        // before swaping the views, we'll take a "screenshot" of the current view
        // by rendering its CALayer into the an ImageContext then saving that off to a UIImage
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 1.0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        // Read the UIImage object
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image
    }
    
    func isPointEmpty(point : CGPoint, isAlphaArray : NSArray) -> Bool {
        let yArr = isAlphaArray[Int(point.x)] as! NSArray
        
        return yArr[Int(point.y)] as! Bool
    }
    
    // Bresenham's Line Algorithm
    // https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
    func getPointsOnLine(start : CGPoint, end : CGPoint) -> [CGPoint] {
        var result : [CGPoint] = []
        
        var x0 = Int(start.x)
        var x1 = Int(end.x)
        var y0 = Int(start.y)
        var y1 = Int(end.y)
        
        var dX = x1 - x0
        var dY = y1 - y0
        let steep = (abs(dY) >= abs(dX))
        
        if (steep == true) {
            swap(&x0, &y0)
            swap(&x1, &y1)
            dX = x1 - x0
            dY = y1 - y0
        }
        
        var xstep = 1
        if (dX < 0) {
            xstep = -1
            dX = -dX
        }
        
        var ystep = 1
        if (dY < 0) {
            ystep = -1
            dY = -dY
        }
        
        let twoDY = 2 * dY
        let twoDYTwoDX = twoDY - 2 * dX
        var e = twoDY - dX
        
        var y = y0
        var xDraw : Int, yDraw : Int
        
        for (var x = x0; x != x1; x += xstep) {
            if (steep == true) {
                xDraw = y
                yDraw = x
            } else {
                xDraw = x
                yDraw = y
            }
            
            result.append(CGPointMake(CGFloat(xDraw), CGFloat(yDraw)))
            
            if (e > 0) {
                e += twoDYTwoDX
                y = y + ystep
            } else {
                e += twoDY
            }
        }
        
        return result
    }
    
    func getIntersectWithImage(startPoint : CGPoint, endPoint : CGPoint, alphaArray : NSArray, margin : Int) -> CGPoint {
        var result = endPoint
        
        let pointsOnLine = getPointsOnLine(startPoint, end: endPoint)
        var i = 0
        for pt in pointsOnLine {
            if !isPointEmpty(pt, isAlphaArray: alphaArray) {
                result = pointsOnLine[max(0, i - margin)]
                break
            }
            ++i
        }
        return result
    }
    
    public func getBezierOutlineAsync(stepValue : Int, margin : Int, completion : (bezier : UIBezierPath) -> Void) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let outline = self.getBezierOutline(stepValue, margin: margin)
            completion(bezier: outline)
        }
    }
    
    public func getBezierOutline(stepValue : Int, margin : Int) -> UIBezierPath {
        var points : [CGPoint] = []
        let imageScaled = self.imageForView()
        let width = imageScaled.size.width
        let height = imageScaled.size.height
        let center = CGPointMake(width/2, height/2)
        let stepY = stepValue
        let stepX = stepValue
        let alphaArray = imageScaled.getIsAlphaArray()
        
        // left
        for (var currentY = 0; currentY < Int(height-1); currentY = currentY + stepY) {
            points.append(getIntersectWithImage(CGPointMake(0, CGFloat(currentY)), endPoint: center, alphaArray: alphaArray, margin: margin))
        }
        
        // bottom
        for (var currentX = 0; currentX < Int(width-1); currentX = currentX + stepX) {
            points.append(getIntersectWithImage(CGPointMake(CGFloat(currentX) ,height-1), endPoint: center, alphaArray: alphaArray, margin: margin))
        }
        
        // right
        for (var currentY = Int(height-1); currentY > 0; currentY = currentY - stepY) {
            points.append(getIntersectWithImage(CGPointMake(width-1, CGFloat(currentY)), endPoint: center, alphaArray: alphaArray, margin: margin))
        }
        
        // top
        for (var currentX = Int(width-1); currentX > 0; currentX = currentX - stepX) {
            points.append(getIntersectWithImage(CGPointMake(CGFloat(currentX), 0), endPoint: center, alphaArray: alphaArray, margin: margin))
        }
        
        let bezier = UIBezierPath()
        bezier.moveToPoint(points.removeAtIndex(0))
        for pt in points {
            bezier.addLineToPoint(pt)
        }
        
        bezier.closePath()
        
        return bezier
    }
    
}