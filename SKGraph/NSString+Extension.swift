//
//  NSString+Extension.swift
//  SKGraph
//
//  Created by Kusal Shrestha on 8/29/16.
//  Copyright © 2016 Kusal Shrestha. All rights reserved.
//

import Foundation
import UIKit

extension NSString {
    
    func drawText(basePoint:CGPoint, angle:CGFloat, font:UIFont, color: UIColor = UIColor.whiteColor()) {
        
        let attrs: NSDictionary = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color]
        
        let textSize:CGSize = self.sizeWithAttributes(attrs as? [String : AnyObject])
        
        // sizeWithAttributes is only effective with single line NSString text
        // use boundingRectWithSize for multi line text
        
        let context: CGContextRef =   UIGraphicsGetCurrentContext()!
        
        let t:CGAffineTransform   =   CGAffineTransformMakeTranslation(basePoint.x, basePoint.y)
        let r:CGAffineTransform   =   CGAffineTransformMakeRotation(angle)
        
        
        CGContextConcatCTM(context, t)
        CGContextConcatCTM(context, r)
        
        
        self.drawAtPoint(CGPointMake(-1 * textSize.width / 2, -1 * textSize.height / 2), withAttributes: attrs as? [String : AnyObject])
        
        
        CGContextConcatCTM(context, CGAffineTransformInvert(r))
        CGContextConcatCTM(context, CGAffineTransformInvert(t))
    }
    
    
    func digitsOnly() -> Double {
        let stringArray = self.componentsSeparatedByCharactersInSet(
            NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let newString = stringArray.joinWithSeparator("")
        
        return Double(newString) ?? 0.0
    }
    
}