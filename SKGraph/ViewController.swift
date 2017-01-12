//
//  ViewController.swift
//  SKGraph
//
//  Created by Kusal Shrestha on 8/16/16.
//  Copyright © 2016 Kusal Shrestha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var skGraph: SKGraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let manager = SKGraphManager(withXDataLabels: ["Sa", "Su", "Mo", "Tu", "We", "Th", "Fr"],
                                     ylabels: ["65%", "70%", "75%", "80%", "85%", "90%", "95%", "100%"],
                                     xTitle: "Days",
                                     mainTitle: "SKGraph")
        let firstDataSet = SKData(dataSet: [85, 80, 65, 75, 90, 95, 100])
        manager.datas = [firstDataSet]
        skGraph.meanData = 78
        skGraph.dataManager = manager
    }
    
    @IBAction func switchAction(sender: UISwitch) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

