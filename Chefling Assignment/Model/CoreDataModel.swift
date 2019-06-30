//
//  CoreDataModel.swift
//  Chefling Assignment
//
//  Created by GAURAV NAYAK on 30/06/19.
//  Copyright © 2019 GAURAV NAYAK. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataModel {
    
    static let shared = CoreDataModel()
    
    func addForecastCoreData(forecast_max: Double, forecast_icon: String, forecast_day: String, day: Int, forecast_min: Double) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Forecast_Data", in: context)
        
        let addCurrent = NSManagedObject(entity: entity!, insertInto: context)
        addCurrent.setValue(forecast_min , forKey: "forecast_min")
        addCurrent.setValue(forecast_max , forKey: "forecast_max")
        addCurrent.setValue(forecast_icon , forKey: "forecast_icon")
        addCurrent.setValue(forecast_day , forKey: "forecast_day")
        addCurrent.setValue(day , forKeyPath: "index")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func showPreviousData(completionHandler: @escaping (Current?, [[Forecast]]?) -> Void) {
        
        var forecast = Array(repeating: Array(repeating: Forecast(), count: 0), count: 5)
        var current = Current()
        let currentTemp = UserDefaults.standard.double(forKey: "CurrentTemp") ?? 0.0
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Forecast_Data")
        
        do {
            let result = try context.fetch(request)
            
            if result.count >= 5 {
                for data in result as! [NSManagedObject] {
            
                    switch data.value(forKey: "index") as! Int16 {
                    case 0:
                        forecast[0].append(Forecast(temp_max: (data.value(forKey: "forecast_max") as! Double), temp_min: (data.value(forKey: "forecast_min") as! Double), day: (data.value(forKey: "forecast_day") as! String), icon: (data.value(forKey: "forecast_icon") as! String)))
                        current.temp_min = (data.value(forKey: "forecast_min") as! Double)
                        current.temp_max = (data.value(forKey: "forecast_max") as! Double)
                        current.icon = (data.value(forKey: "forecast_icon") as! String)
                        current.temp = currentTemp
                    case 1:
                        forecast[1].append(Forecast(temp_max: (data.value(forKey: "forecast_max") as! Double), temp_min: (data.value(forKey: "forecast_min") as! Double), day: (data.value(forKey: "forecast_day") as! String), icon: (data.value(forKey: "forecast_icon") as! String)))
                    case 2:
                        forecast[2].append(Forecast(temp_max: (data.value(forKey: "forecast_max") as! Double), temp_min: (data.value(forKey: "forecast_min") as! Double), day: (data.value(forKey: "forecast_day") as! String), icon: (data.value(forKey: "forecast_icon") as! String)))
                    case 3:
                        forecast[3].append(Forecast(temp_max: (data.value(forKey: "forecast_max") as! Double), temp_min: (data.value(forKey: "forecast_min") as! Double), day: (data.value(forKey: "forecast_day") as! String), icon: (data.value(forKey: "forecast_icon") as! String)))
                    case 4:
                        forecast[4].append(Forecast(temp_max: (data.value(forKey: "forecast_max") as! Double), temp_min: (data.value(forKey: "forecast_min") as! Double), day: (data.value(forKey: "forecast_day") as! String), icon: (data.value(forKey: "forecast_icon") as! String)))
                    default:
                        print("Dump")
                    }
                }
                completionHandler(current, forecast)
            }
            else {
               completionHandler(nil, nil)
            }
        } catch {
            completionHandler(nil, nil)
            print("Failed")
        }
    }
    
    func clear() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Forecast_Data")
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        fetchRequest.includesPropertyValues = false
        
        do {
            let items = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                managedObjectContext.delete(item)
            }
            try managedObjectContext.save()
            
        } catch {
            print("Error")
        }
    }
}
