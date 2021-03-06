//
//  DistancePicker.swift
//  CG4 Coursework
//
//  Created by William Ray on 17/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class DistancePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    /**
    This method is called when the class initialises. It sets the delegate of the picker view to this class.
    
    :param: coder An NSCoder that is used to unarchive the class.
    */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        self.delegate = self
        self.dataSource = self
    }

    // MARK: - Picker View Data Source

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 2 {
            return 2
        } else {
            return 100
        }
    }

    /**
    This method is called by the system in order to set up the picker view. It returns the title for a row in a component.
    1. IF the component is the first component
        a. Return the row number as string
    2. ELSE IF the component is the second
        b. Return the row number as a string in the form '.ROW' using 2 digits (e.g. 2 would be 02)
    3. ELSE
        c. IF the row is the first
            i. Return 'mi'
        d. ELSE
            i. Return 'km'
    
    :param: pickerView The UIPickerView requesting the number of components.
    :param: row An integer identifying the row for which the title should be returned for.
    :param: component An integer identifying the component that the row is in.
    :returns: A string that is the title for the row.
    */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 { //1
            return "\(row)" //a //miles
        } else if component == 1 { //2
            return NSString(format: ".%02i", row) as String //b //hundredths of a mile
        } else { //3
            //units
            if row == 0 { //c
                return "mi" //i
            } else { //d
                return "km" //i
            }
        }
    }

    /**
    This method is called by the system when a user selects a row in a component. It posts a notification called UpdateDateDetailLabel passing the user info of a dictionary with the value 'DISTANCE' stored for the key 'valueChanged'.
    
    :param: pickerView The UIPickerView informing the delegate that a row has been selected.
    :param: row An integer identifying the row which was selected.
    :param: component An integer identifying the component that the row is in.
    */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateDetailLabel"), object: nil, userInfo: NSDictionary(object: "DISTANCE", forKey: "valueChanged" as NSCopying) as! [AnyHashable: Any])
    }

    /**
    This method is called to return the selected distance. It returns the distance as a double (in miles) and the distance as a string (in the form DISTANCE unit).
    1. Declares the local double variable distance
    2. Delcares the local string variable distanceStr
    3. IF the selected row in the last (unit) component is the first
        a. Declares the local double constant miles as the selected row in the first component
        b. Declares the local double constant hundredthsMiles as the selected row in the second component
        c. Sets the distance equal to the miles plus the hundredthsMile divided by 100
        d. Sets the distance string as the 'DISTANCE mi"
    4. ELSE
        a. Declares the local double constant kilometres as the selected row in the first component
        b. Declares the local double constant hundredthsKilometres as the selected row in the second component
        c. Declares the local double constant totalKmDistance as the kilometres plus the hundredthsKilometres divided by 100
        d. Sets the distance equal to the totalKmDistance converted to miles
        e. Sets the distance string as the "totalKmDistance km"
    
    Uses the following local variables:
        distance - A double variable that stores the selected distance
        distanceStr - A string variable that stores the selected distance as a string
        miles - A double constant that is the selected number of whole miles
        hundredthsMiles - A double constant that is the selected number of hundredths of miles
        kilometres - A double constant that is the selected number of whole kilometres
        hundredthsKilometres - A double constant that is the selected number of hundredths of kilometres
    
    :returns: distance - The distance selected in the picker as a double.
    :returns: distanceStr - The distance selected as a string in the user's chosen unit.
    */
    func selectedDistance() -> (distance: Distance<Miles>, distanceStr: String) {
        var distance = 0.00
        var distanceStr = ""

        if self.selectedRow(inComponent: 2) == 0 {
            //The picker is in MILES
            let miles = Double(self.selectedRow(inComponent: 0))
            let hundredthsMiles = Double(self.selectedRow(inComponent: 1))

            distance = miles + (hundredthsMiles/100)
            distanceStr = "\(distance) mi"
        } else {
            //The picker is in KILOMETRES
            let kilometres = Double(self.selectedRow(inComponent: 0))
            let hundredthsKilometres = Double(self.selectedRow(inComponent: 1))

            let totalKmDistance = kilometres + (hundredthsKilometres/100)

            distance = Conversions.kmToMiles * totalKmDistance
            distanceStr = "\(totalKmDistance) km"
        }

        return (Distance<Miles>(distance), distanceStr)
    }

    /**
    This method is called to set the picker to a certain distance (used in the Add New Run View Controller)
    1. Declares the local integer constant miles as the integer value of the distance
    2. Declares the local integer constant hundredthsMiles as the (distance minus the number of miles) * 100 converted to an integer
    3. Sets the selected row in the first component as the number of miles
    4. Sets the selected row in the second component as the number of hundredths of miles
    5. Sets the selected row in the third component as the 'mi' unit
    
    Uses the following local variables:
        miles - A constant integer that is the number of whole miles to set the distance to
        hundredthsMiles - A constant integer that is the number of hundredths of miles to set the distance to
    
    :param: distance The distance to set the picker to as a double in miles.
    */
    func setDistance(distance: Distance<Miles>) {
        let miles = Int(distance.rawValue) //1
        let hundredthsMiles = Int(((distance - miles.miles) * 100).rawValue) //2

        self.selectRow(miles, inComponent: 0, animated: false) //3
        self.selectRow(hundredthsMiles, inComponent: 1, animated: false) //4
        self.selectRow(0, inComponent: 2, animated: false) //5
    }
}
