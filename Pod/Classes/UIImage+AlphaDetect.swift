//
//  UIImage+AlphaDetect.swift
//  Pods
//
//  Created by Mani Ghasemlou on 2015-09-27.
//
//

import Foundation

extension UIImage {
    func getIsAlphaArray() -> NSArray {
        
        let imageRef : CGImageRef = self.CGImage!
        let width = CGImageGetWidth(imageRef)
        let height = CGImageGetHeight(imageRef)
        
        let result = NSMutableArray(capacity: width)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rawData = UnsafeMutablePointer<CUnsignedChar>(calloc(height*width*4, sizeof(CUnsignedChar)))
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, CGImageAlphaInfo.PremultipliedLast.rawValue | CGBitmapInfo.ByteOrder32Big.rawValue)
        CGContextDrawImage(context, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), imageRef)
        
        for (var x = 0; x < Int(self.size.width); ++x) {
            result.addObject(NSMutableArray(capacity: height))
            for (var y = 0; y < Int(self.size.height); ++y) {
                let byteIndex = (bytesPerRow * y) + x * bytesPerPixel
                let isAlpha = (Double(rawData[byteIndex + 3]) / 255.0) == 0
                result.objectAtIndex(x).addObject(isAlpha)
            }
        }
        
        free(rawData)
        
        return result
    }
}