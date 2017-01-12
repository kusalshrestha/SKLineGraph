//
//  SKGraphDataManager.swift
//  SKGraph
//
//  Created by Kusal Shrestha on 8/21/16.
//  Copyright © 2016 Kusal Shrestha. All rights reserved.
//

import Foundation

struct SKData {
    var dataSet = [Double]()
}

class SKGraphManager {
    
    var datas = [SKData]() {
        didSet {
            // calculate min max from each set.... MAke a new set from them and recalculate their min max value
            /*var newSampleDataSet = [Double]()
            for data in datas {
                let minMax = calculateMinMax(data.dataSet)
                newSampleDataSet.append(minMax.max)
                newSampleDataSet.append(minMax.min)
            }
            
            let finalMinMax = calculateMinMax(newSampleDataSet)
            lowestData = finalMinMax.min
            highestData = finalMinMax.max*/
            var labelArray = [Double]()
            for label in yDataLabels {
                labelArray.append(label.digitsOnly())
            }
            let minMax = calculateMinMax(labelArray)
            lowestData = minMax.min
            highestData = minMax.max
        }
    }
    
    var meanData: Double?
    var xDataLabels = [String]()
    var yDataLabels = [String]()//["0", "4", "8", "12", "16", "20", "24"]
    
    var xTitle = ""
    var yTitle = ""
    var mainTitle = ""
    
    var lowestData: Double! {   // if lowestData is 3 then rounds to 0
        didSet {
            // TODO: Dynamically claculate this
            lowestPoint = 0 // 0:00 hrs
        }
    }
    
    var highestData: Double! {   // if highestData is 7 then rounds to 10
        didSet {
            // TODO: Dynamically claculate this
            highestPoint = 1440 // 24:00 hrs in minutes
        }
    }
    
    var lowestPoint: Double!
    var highestPoint: Double!
        
    init() {}
    
    init(withXDataLabels xlabels: [String], ylabels: [String], xTitle: String = "", yTitle: String = "", mainTitle: String = "") {
        xDataLabels = xDataLabels + xlabels
        yDataLabels = yDataLabels + ylabels
        
        self.xTitle = xTitle
        self.yTitle = yTitle
        self.mainTitle = mainTitle
    }
    
    // Calculates minimum and maximum values from an Array
    private func calculateMinMax(dataSet: [Double]) -> (min: Double, max: Double) {
        var min: Double = dataSet.first!
        var max: Double = dataSet.first!
        
        for skData in datas {
            for data in skData.dataSet {
                if data < min {
                    min = data
                }
                if data > max {
                    max = data
                }
            }
        }
        return (min, max)
    }
    
    func roundToTens(x : Double) -> Int {
        return 10 * Int(round(x / 10.0))
    }
    
}
