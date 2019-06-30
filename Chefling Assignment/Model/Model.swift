//
//  Model.swift
//  Chefling Assignment
//
//  Created by GAURAV NAYAK on 27/06/19.
//  Copyright © 2019 GAURAV NAYAK. All rights reserved.
//

import Foundation

var currentCity : String = UserDefaults.standard.string(forKey: "City") ?? "Bangalore"

struct Current {
    var temp : Double?
    var temp_max : Double?
    var temp_min : Double?
    var description : String?
    var icon : String?
}

struct Forecast {
    var temp_max : Double?
    var temp_min : Double?
    var day : String?
    var icon : String?
}

var forcasts = [Forecast()]
