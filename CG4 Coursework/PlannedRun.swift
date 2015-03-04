//
//  PlannedRun.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class PlannedRun: NSObject {
    
    var ID: Int
    var date: NSDate
    var distance: Double
    var duration: Int
    var details: String?
    
    init(ID: Int, date: NSDate, distance: Double, duration: Int, details: String?) {
        self.ID = ID
        self.date = date
        self.distance = distance
        self.duration = duration
        self.details = details
    }
    
    func checkForCompletedRun() -> (rank: Int, run: Run?) {
        let runs = Database().loadRunsWithQuery("WHERE RunDateTime LIKE '%\(self.date.shortDateString())%'") as Array<Run>
        var rank = 0
        var matchingRun: Run?
        
        for run: Run in runs {
            if rank < 2 {
                if run.distance >= self.distance {
                    rank = 2
                    matchingRun = run
                } else if run.duration >= self.duration {
                    rank = 2
                    matchingRun = run
                }
            } else if rank < 1 {
                if run.distance >= self.distance {
                    rank = 1
                    matchingRun = run
                } else if run.duration >= self.duration {
                    rank = 1
                    matchingRun = run
                }
            }
        }
        
        return (rank, matchingRun)
    }
}
