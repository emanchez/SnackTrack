//
//  MetricsViewController.swift
//  SnapTrack
//
//  Created by Kevin Delgado on 4/12/19.
//  Copyright © 2019 Lilybeth Delgado. All rights reserved.
//

import Foundation
import UIKit
import Charts

class MetricsViewController: UIViewController{
    
    //var fruits:[String]!
    //var dates:[Date]!
    
    
    var dataEntries: [BarChartDataEntry] = []
    @IBOutlet weak var chart: HorizontalBarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chart.drawBarShadowEnabled = false
        chart.drawValueAboveBarEnabled = true
        chart.maxVisibleCount = 50
        chart.backgroundColor = UIColor.white
        
        let xAxis  = chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 10.0
        
        let leftAxis = chart.leftAxis;
        leftAxis.drawAxisLineEnabled = true;
        leftAxis.drawGridLinesEnabled = true;
        leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
        
        let rightAxis = chart.rightAxis
        rightAxis.enabled = true;
        
        rightAxis.drawAxisLineEnabled = true;
        rightAxis.drawGridLinesEnabled = false;
        rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
        
        let l = chart.legend
        l.enabled =  false
        
        chart.fitBars = true;
        
        setDataCount(count: 7, range: 50)
    
    }
    
   
    func setDataCount(count: Int, range: Double) {
        
        
    }
}
 

