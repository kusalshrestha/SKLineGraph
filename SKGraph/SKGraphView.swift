//
//  SKGraphView.swift
//  SKGraph
//
//  Created by Kusal Shrestha on 8/16/16.
//  Copyright © 2016 Kusal Shrestha. All rights reserved.
//

import UIKit

typealias linePosAndLength = (length: CGFloat, startPos: CGFloat)

class SKGraphView: UIView {

    let linePadding: CGFloat = 8
    
    var dataManager = SKGraphManager() {
        didSet {
            createPoints()
            setNeedsDisplay()
        }
    }
    
    var mainTitle: String = "SKGraph" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var xTitle: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }

    var yTitle: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }

    var xStart: CGFloat!
    var yStart: CGFloat!
    var xEnd: CGFloat!
    var yEnd: CGFloat!
    
    var xInterval: CGFloat!
    var yInterval: CGFloat!
    
    var dotPointsLayers = [DotLayer]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureStartAndEndPoints()
    }
    
    convenience init(withDataManager manager: SKGraphManager) {
        self.init(frame: CGRectZero)
        dataManager = manager
        configureStartAndEndPoints()
    }
    
    func createPoints() {
        guard dataManager.datas.count <= dataManager.xDataLabels.count else {
            return
        }
        for datas in dataManager.datas {
            for _ in  datas.dataSet {
                let dot = DotLayer(strokeColor: UIColor.whiteColor(), fillColor: UIColor(hex: 0x5BB5AC), selected: false)//(color: UIColor.whiteColor(), selected: false)
                dotPointsLayers.append(dot)
                layer.addSublayer(dot)
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        drawTitleLabels()
        drawLines()
        drawDataLabels()
        drawPoints()
        drawLineJoiningPoints()
    }
    
    func drawLineJoiningPoints() {
        guard dataManager.datas.first!.dataSet.count <= dataManager.xDataLabels.count else {
            return
        }
        for i in 0...dataManager.datas.first!.dataSet.count - 1 {
            if i != dataManager.datas.first!.dataSet.count - 1 {
                let startPoint = dotPointsLayers[i].center
                let endPoint = dotPointsLayers[i + 1].center
                DotLayer.drawLinesBetweenTwoPoints(startPoint, endPoint: endPoint)
            }
        }
    }
    
    func drawPoints() {
        guard dataManager.datas.first!.dataSet.count <= dataManager.xDataLabels.count else {
            return
        }
        for i in 0...(dotPointsLayers.count - 1) {
            let dot = dotPointsLayers[i]
            dot.center = CGPoint(x: xStart + CGFloat(i) * xInterval, y: yStart - CGFloat(dataManager.datas.first!.dataSet[i] / dataManager.highestData) * yInterval * 6)
        }
    }
    
    func drawLines() {
        drawXLines()
        drawYLines()
    }
    
    func drawDataLabels() {
        drawTextLabels(dataManager.xDataLabels, isVerticalLabels: false)
        drawTextLabels(dataManager.yDataLabels, isVerticalLabels: true)
    }
    
    func drawTitleLabels() {
        let fieldFont = UIFont(name: "Helvetica Neue", size: 14)
        
        "Hours".drawText(CGPointMake(16, bounds.height / 2), angle: CGFloat(-M_PI_2), font: fieldFont!)

        "Days".drawText(CGPointMake(bounds.width / 2, bounds.height - 14 - 16), angle: CGFloat(0), font: fieldFont!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureStartAndEndPoints()
        setNeedsDisplay()
    }
    
    func configureStartAndEndPoints() {
        xStart = 65
        yStart = bounds.height - 85
        xEnd = bounds.width - 40
        yEnd = 85
        
        xInterval = abs(xEnd - xStart) / CGFloat(dataManager.xDataLabels.count - 1)
        yInterval = abs(yStart - yEnd) / CGFloat(dataManager.yDataLabels.count - 1)
    }
    
    func drawXLines() {
        let xpath = UIBezierPath()
    
        for i in 0...(dataManager.yDataLabels.count - 1) {
            xpath.moveToPoint(CGPoint(x: xStart - linePadding, y: yStart - CGFloat(i) * yInterval))
            xpath.addLineToPoint(CGPoint(x:xEnd + linePadding, y: yStart - CGFloat(i) * yInterval))
        }
        UIColor(hex: 0xB8E1DF).setStroke()
        xpath.stroke()
    }
    
    func drawYLines() {
        let ypath = UIBezierPath()
        
        for i in 0...(dataManager.xDataLabels.count - 1) {
            ypath.moveToPoint(CGPoint(x: xStart + CGFloat(i) * xInterval, y: yStart + linePadding))
            ypath.addLineToPoint(CGPoint(x:xStart + CGFloat(i) * xInterval, y: yEnd - linePadding))
        }
        UIColor(hex: 0xB8E1DF).setStroke()
        ypath.stroke()
    }
    
    func drawTextLabels(textLabels: [String], isVerticalLabels: Bool) {
        for i in 0...textLabels.count - 1 {
            let text = textLabels[i]
            let myString: NSString = text as NSString
            let attrib = [NSFontAttributeName: UIFont.systemFontOfSize(14),
                          NSForegroundColorAttributeName: UIColor.whiteColor()]
            let size: CGSize = myString.sizeWithAttributes(attrib)
            
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.Center

            var rect = CGRectZero
            if isVerticalLabels {
                rect = CGRect(origin: CGPoint(x: xStart - size.width - 15, y: yStart - CGFloat(i) * yInterval - size.height / 2), size: size)
            } else {
                rect = CGRect(origin: CGPoint(x: xStart + CGFloat(i) * xInterval - size.width / 2, y: yStart + size.height), size: size)
            }
            text.drawInRect(rect, withAttributes: attrib)
        }
    }
 
}
