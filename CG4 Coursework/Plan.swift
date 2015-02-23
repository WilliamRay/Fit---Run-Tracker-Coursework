//
//  Plan.swift
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

import UIKit

class Plan: NSObject {

    var ID: Int
    var name: String
    var startDate: NSDate
    var endDate: NSDate
    var active = false
    var plannedRuns = [PlannedRun]()
    
    init(ID: Int, name: String, startDate: NSDate, endDate: NSDate) {
        self.ID = ID
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        
        super.init()
        self.checkIfActive()
        self.loadPlannedRuns()
    }
    
    func checkIfActive() {
        let today = NSDate()
        let endDate = self.endDate.dateByAddingTimeInterval(86400) //Add a day to the date.
        
        if today.earlierDate(startDate) == startDate && today.laterDate(endDate) == endDate {
            self.active = true
        } else {
            self.active = false
        }
    }
    
    func loadPlannedRuns() {
        plannedRuns = Database().loadPlannedRunsForPlan(self) as Array<PlannedRun>
    }
}
