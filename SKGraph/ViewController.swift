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

        let manager = SKGraphManager(withDataLabels: ["Sa", "Su", "Mo", "Tu", "We", "Th", "Fr"], xTitle: "Days", yTitle: "Hours", mainTitle: "SKGraph")
        let firstDataSet = SKData(dataSet: [1, 5, 3, 8, 2, 24, 1])
        manager.datas = [firstDataSet]
        skGraph.dataManager = manager        
    }
    
    @IBAction func switchAction(sender: UISwitch) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

