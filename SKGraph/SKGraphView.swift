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
            clearDrawing()
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
    
    var meanDataInPercentage: Double?
    
    
    var xpath: UIBezierPath!
    var ypath: UIBezierPath!
    var meanLine: UIBezierPath!
    var collectiveDotLayer = CALayer()
    var collectiveLinePath = [UIBezierPath]()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    convenience init(withDataManager manager: SKGraphManager) {
        self.init(frame: CGRectZero)
        dataManager = manager
        configureStartAndEndPoints()
    }
    
    override func drawRect(rect: CGRect) {
        drawLines()
        positionPoints()
        drawDataLabels()
        drawTitleLabels()
        drawLineJoiningPoints()
        drawMeanLine()
    }
    
    func clearDrawing() {
        xpath = nil
        ypath = nil
        meanLine = nil
        collectiveDotLayer.removeFromSuperlayer()
        for var linePath in collectiveLinePath {
            linePath = UIBezierPath()
        }
        setNeedsDisplay()
    }
    
    private func drawLineJoiningPoints() {
        guard dataManager.datas.count != 0 else { return }
        guard dataManager.datas[0].dataSet.count <= dataManager.xDataLabels.count else {
            return
        }
        var collectiveLine = [UIBezierPath]()
        for i in 0...dataManager.datas[0].dataSet.count - 1 {
            if i != dataManager.datas[0].dataSet.count - 1 {
                let startPoint = dotPointsLayers[i].center
                let endPoint = dotPointsLayers[i + 1].center
                let line = DotMarker.drawLinesBetweenTwoPoints(startPoint, endPoint: endPoint)
                collectiveLine.append(line)
            }
        }
        collectiveLinePath = collectiveLine
    }
    
    private func createPoints() {
        guard dataManager.datas.count != 0 else { return }
        guard dataManager.datas.count <= dataManager.xDataLabels.count else {
            return
        }
        for dot in dotPointsLayers {
            dot.removeFromSuperlayer()
        }
        dotPointsLayers = [DotMarker]()
        let collectiveLayers = CALayer()
        for datas in dataManager.datas {
            for _ in  datas.dataSet {
                let dot = DotMarker(strokeColor: lineStrokeColor, fillColor: backgroundColor ?? UIColor.grayColor(), selected: false)
                dotPointsLayers.append(dot)
                collectiveLayers.addSublayer(dot)
            }
        }
        collectiveDotLayer = collectiveLayers
        layer.addSublayer(collectiveDotLayer)
    }
    
    private func positionPoints() {
        guard dataManager.datas.count != 0 else { return }
        guard dataManager.datas[0].dataSet.count <= dataManager.xDataLabels.count else {
            return
        }
        let lastNumberInSet = dataManager.yDataLabels[dataManager.yDataLabels.count - 1].digitsOnly()
        var firstNumberInSet = dataManager.yDataLabels[0].digitsOnly()
        if dataManager.yDataLabels[0].isEmpty {
            let secondNumber = dataManager.yDataLabels[1].digitsOnly()
            let fourthNumber = dataManager.yDataLabels[3].digitsOnly()
            let delta = (fourthNumber - secondNumber) / 2
            firstNumberInSet = secondNumber - delta
        } else {
            firstNumberInSet = dataManager.yDataLabels[0].digitsOnly()
        }
        for i in 0...(dotPointsLayers.count - 1) {
            let dot = dotPointsLayers[i]
            dot.center = CGPoint(x: xStart + CGFloat(i) * xInterval, y: yStart - (CGFloat((dataManager.datas[0].dataSet[i] - firstNumberInSet) / (lastNumberInSet - firstNumberInSet))) * yInterval * CGFloat(dataManager.yDataLabels.count - 1))
        }
    }
    
    private func drawLines() {
        drawXLines()
        drawYLines()
    }
    
    private func drawDataLabels() {
        drawTextLabels(dataManager.xDataLabels, isVerticalLabels: false)
        drawTextLabels(dataManager.yDataLabels, isVerticalLabels: true)
    }
    
    private func drawTitleLabels() {
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
    
    private func configureStartAndEndPoints() {
        xStart = 65
        yStart = bounds.height - 85
        xEnd = bounds.width - 40
        yEnd = 85
        
        xInterval = abs(xEnd - xStart) / CGFloat(dataManager.xDataLabels.count - 1)
        yInterval = abs(yStart - yEnd) / CGFloat(dataManager.yDataLabels.count - 1)
    }
    
    private func drawXLines() {
        xpath = UIBezierPath()
    
        for i in 0...(dataManager.yDataLabels.count - 1) {
            xpath.moveToPoint(CGPoint(x: xStart - linePadding, y: yStart - CGFloat(i) * yInterval))
            xpath.addLineToPoint(CGPoint(x:xEnd + linePadding, y: yStart - CGFloat(i) * yInterval))
        }
        graphLineColor.setStroke()
        xpath.stroke()
    }
    
    private func drawYLines() {
        ypath = UIBezierPath()
        
        for i in 0...(dataManager.xDataLabels.count - 1) {
            ypath.moveToPoint(CGPoint(x: xStart + CGFloat(i) * xInterval, y: yStart + linePadding))
            ypath.addLineToPoint(CGPoint(x:xStart + CGFloat(i) * xInterval, y: yEnd - linePadding))
        }
        graphLineColor.setStroke()
        ypath.stroke()
    }
    
    private func drawTextLabels(textLabels: [String], isVerticalLabels: Bool) {
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
    
    private func drawMeanLine() {
        guard let _ = meanDataInPercentage else { return }
        meanLine = UIBezierPath()
        let lastNumberInSet = dataManager.yDataLabels[dataManager.yDataLabels.count - 1].digitsOnly()
        let firstNumberInSet = dataManager.yDataLabels[0].digitsOnly()
        guard let meanValue = meanDataInPercentage else { return }
        meanLine.moveToPoint(CGPoint(x: xStart - linePadding, y: yStart - (CGFloat((meanValue - firstNumberInSet) / (lastNumberInSet - firstNumberInSet))) * yInterval * CGFloat(dataManager.yDataLabels.count - 1)))
        meanLine.addLineToPoint(CGPoint(x:xEnd + linePadding, y: yStart - (CGFloat((meanValue - firstNumberInSet) / (lastNumberInSet - firstNumberInSet))) * yInterval * CGFloat(dataManager.yDataLabels.count - 1)))
    
        graphMeanLineColor.setStroke()
        meanLine.stroke()
    }
 
}

extension SKGraphView: SKGraphDataDelegate {
    
    func loadData() {
        createPoints()
        setNeedsDisplay()
    }
    
}
