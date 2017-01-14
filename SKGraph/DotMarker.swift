//
//  DotLayer.swift
//  SKGraph
//
//  Created by Kusal Shrestha on 8/19/16.
//  Copyright © 2016 Kusal Shrestha. All rights reserved.
//

import Foundation
import UIKit

class DotMarker: CAShapeLayer {
    
    var layerBorderColor = UIColor.whiteColor()
    var layerFillColor = UIColor.clearColor()
    var dotPath: UIBezierPath!
    
    let normalDotWidth: CGFloat = 2
    let selectedDotWidth: CGFloat = 5
    
    let dotSize = CGSize(width: 10, height: 10)

    var center = CGPointZero {
        didSet {
            if isSelected {
                position = CGPoint(x: center.x - dotSize.width / 2, y: center.y - dotSize.height / 2)
            } else {
                position = CGPoint(x: center.x - dotSize.width / 2, y: center.y - dotSize.height / 2)
            }
        }
    }
    
    var isSelected = false {
        didSet {
            if isSelected {
                lineWidth = selectedDotWidth
                fillColor = layerBorderColor.CGColor
            } else {
                lineWidth = normalDotWidth
                fillColor = layerFillColor.CGColor
            }
        }
    }
    
    private override init() {
        super.init()
    }
    
    private override init(layer: AnyObject) {
        super.init()
    }
    
    convenience init(strokeColor: UIColor, fillColor: UIColor, selected: Bool) {
        self.init()
        
        layerBorderColor = strokeColor
        layerFillColor = fillColor
        isSelected = selected
        backgroundColor = UIColor.clearColor().CGColor
        setUpLayer()
    }
    
    func setUpLayer() {
        dotPath = UIBezierPath(roundedRect: CGRect(origin: CGPointZero, size: dotSize), cornerRadius: dotSize.width / 2)
        self.path = dotPath.CGPath
        lineWidth = isSelected ? selectedDotWidth : normalDotWidth
        fillColor = isSelected ? layerBorderColor.CGColor : layerFillColor.CGColor
        strokeColor = layerBorderColor.CGColor
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
    }
    
    class func drawLinesBetweenTwoPoints(startPoint: CGPoint, endPoint: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(startPoint)
        path.addLineToPoint(endPoint)
        path.lineWidth = 2
        UIColor.whiteColor().setStroke()
        path.stroke()
        return path
    }
    
}

