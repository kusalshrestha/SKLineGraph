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
            dataManager.delegate = self
            createPoints()
            setNeedsDisplay()
        }
    }
    
// MARK: - Titles
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
    
// MARK:- Colors
    var lineStrokeColor: UIColor = UIColor.whiteColor()
    var graphLineColor: UIColor = UIColor(hex: 0xFFFFFF, alpha: 0.4)
    var graphMeanLineColor: UIColor = UIColor.greenColor()

    var xStart: CGFloat!
    var yStart: CGFloat!
    var xEnd: CGFloat!
    var yEnd: CGFloat!
    
    var xInterval: CGFloat!
    var yInterval: CGFloat!
    
    var dotPointsLayers = [DotMarker]()
    
    var meanData: Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    convenience init(withDataManager manager: SKGraphManager) {
        self.init(frame: CGRectZero)
        dataManager = manager
        configureStartAndEndPoints()
    }
    
    func createPoints() {
        guard dataManager.datas.count != 0 else { return }
        guard dataManager.datas.count <= dataManager.xDataLabels.count else {
            return
        }
        for dot in dotPointsLayers {
            dot.removeFromSuperlayer()
        }
        dotPointsLayers = [DotMarker]()
        for datas in dataManager.datas {
            for _ in  datas.dataSet {
                let dot = DotMarker(strokeColor: lineStrokeColor, fillColor: backgroundColor ?? UIColor.grayColor(), selected: false)
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
        drawMeanLine()
    }
    
    func drawLineJoiningPoints() {
        guard dataManager.datas.count != 0 else { return }
        guard dataManager.datas[0].dataSet.count <= dataManager.xDataLabels.count else {
            return
        }
        for i in 0...dataManager.datas[0].dataSet.count - 1 {
            if i != dataManager.datas[0].dataSet.count - 1 {
                let startPoint = dotPointsLayers[i].center
                let endPoint = dotPointsLayers[i + 1].center
                DotMarker.drawLinesBetweenTwoPoints(startPoint, endPoint: endPoint)
            }
        }
    }
    
    func drawPoints() {
        guard dataManager.datas.count != 0 else { return }
        guard dataManager.datas[0].dataSet.count <= dataManager.xDataLabels.count else {
            return
        }
        for i in 0...(dotPointsLayers.count - 1) {
            let dot = dotPointsLayers[i]
            let lastNumberInSet = dataManager.yDataLabels[dataManager.yDataLabels.count - 1].digitsOnly()
            let firstNumberInSet = dataManager.yDataLabels[0].digitsOnly()
            dot.center = CGPoint(x: xStart + CGFloat(i) * xInterval, y: yStart - (CGFloat((dataManager.datas[0].dataSet[i] - firstNumberInSet) / (lastNumberInSet - firstNumberInSet))) * yInterval * CGFloat(dataManager.yDataLabels.count - 1))
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
        let fieldFont = UIFont.systemFontOfSize(14)
        
        dataManager.yTitle.drawText(CGPointMake(16, bounds.height / 2), angle: CGFloat(-M_PI_2), font: fieldFont)

        dataManager.xTitle.drawText(CGPointMake(bounds.width / 2, bounds.height - 14 - 16), angle: CGFloat(0), font: fieldFont)

        dataManager.mainTitle.drawText(CGPointMake(bounds.width / 2, 44), angle: CGFloat(0), font: fieldFont)
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
        graphLineColor.setStroke()
        xpath.stroke()
    }
    
    func drawYLines() {
        let ypath = UIBezierPath()
        
        for i in 0...(dataManager.xDataLabels.count - 1) {
            ypath.moveToPoint(CGPoint(x: xStart + CGFloat(i) * xInterval, y: yStart + linePadding))
            ypath.addLineToPoint(CGPoint(x:xStart + CGFloat(i) * xInterval, y: yEnd - linePadding))
        }
        graphLineColor.setStroke()
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
    
    func drawMeanLine() {
        let xpath = UIBezierPath()
        let lastNumberInSet = dataManager.yDataLabels[dataManager.yDataLabels.count - 1].digitsOnly()
        let firstNumberInSet = dataManager.yDataLabels[0].digitsOnly()
        guard let meanValue = meanData else { return }
        xpath.moveToPoint(CGPoint(x: xStart - linePadding, y: yStart - (CGFloat((meanValue - firstNumberInSet) / (lastNumberInSet - firstNumberInSet))) * yInterval * CGFloat(dataManager.yDataLabels.count - 1)))
        xpath.addLineToPoint(CGPoint(x:xEnd + linePadding, y: yStart - (CGFloat((meanValue - firstNumberInSet) / (lastNumberInSet - firstNumberInSet))) * yInterval * CGFloat(dataManager.yDataLabels.count - 1)))
    
        graphMeanLineColor.setStroke()
        xpath.stroke()
    }
 
}

extension SKGraphView: SKGraphDataDelegate {
    
    func loadData() {
        createPoints()
        setNeedsDisplay()
    }
    
}
