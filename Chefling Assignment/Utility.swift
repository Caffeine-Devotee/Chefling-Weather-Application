//
//  Utility.swift
//  Chefling Assignment
//
//  Created by GAURAV NAYAK on 30/06/19.
//  Copyright © 2019 GAURAV NAYAK. All rights reserved.
//

import Foundation

func findMinimum(theArray: [Forecast]) -> Double  {
    var min : Double = theArray[0].temp_min!
    for item in theArray {
        if item.temp_min! < min {
            min = item.temp_min!
        }
    }
    return min
}

func findMaximum(theArray: [Forecast]) -> Double  {
    var max : Double = theArray[0].temp_max!
    for item in theArray {
        if item.temp_max! > max {
            max = item.temp_max!
        }
    }
    return max
}
