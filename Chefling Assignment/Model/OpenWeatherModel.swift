//
//  OpenWeatherModel.swift
//  Chefling Assignment
//
//  Created by GAURAV NAYAK on 27/06/19.
//  Copyright © 2019 GAURAV NAYAK. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate

class OpenWeatherModel {
    
    static let shared = OpenWeatherModel()
    let networkRequest = NetworkController.init()
    
    init() {
        return
    }
    
    struct Url {
        static let Weather = "https://api.openweathermap.org/data/2.5/weather?"
        static let Forecast = "https://api.openweathermap.org/data/2.5/forecast?"
        static let Icon = "http://openweathermap.org/img/wn/%@@2x.png"
    }
    
    func getWeather(completionHandler: @escaping (Current?) -> Void) {
        
        var currentWeather = Current()
        networkRequest.getRequest(urlString: Url.Weather, location: currentCity) { (check, json) in
            if check {
                
                currentWeather.temp = json["main"]["temp"].double! - 273
                currentWeather.temp_max = json["main"]["temp_max"].double! - 273
                currentWeather.temp_min = json["main"]["temp_min"].double! - 273
                currentWeather.description = json["weather"][0]["description"].string
                currentWeather.icon = json["weather"][0]["icon"].string

                UserDefaults.standard.set(currentWeather.temp, forKey: "CurrentTemp")
                
                completionHandler(currentWeather)
            }
            else {
               completionHandler(nil)
            }
            
        }
        
    }
    
    func getImage(icon: String, completionHandler: @escaping (UIImage?) -> Void) {
        let iconUrl = URL(string: String(format: Url.Icon, icon))!
        networkRequest.downloadImage(url: iconUrl) { (result) in
            completionHandler(result)
        }
    }
    
    func getForecast(completionHandler: @escaping ([[Forecast]]?) -> Void) {
        
        var forecast = Array(repeating: Array(repeating: Forecast(), count: 0), count: 5)
        networkRequest.getRequest(urlString: Url.Forecast, location: currentCity) { (check, json) in
            if check {
                let currentDateTime = Date()
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                let today = formatter.string(from: currentDateTime).toDate()?.date
                
                for (_, subJson) in json["list"] {
                    
                    switch subJson["dt_txt"].string!.toDate()!.date.day {
                    case today?.day:
                        forecast[0].append(Forecast(temp_max: subJson["main"]["temp_max"].double! - 273,
                                                            temp_min: subJson["main"]["temp_min"].double! - 273,
                                                            day: subJson["dt_txt"].string?.toDate()?.weekdayName(.short),
                                                            icon: subJson["weather"][0]["icon"].string))
                    case (today! + 1.days).day:
                        forecast[1].append(Forecast(temp_max: subJson["main"]["temp_max"].double! - 273,
                                                            temp_min: subJson["main"]["temp_min"].double! - 273,
                                                            day: subJson["dt_txt"].string?.toDate()?.weekdayName(.short),
                                                            icon: subJson["weather"][0]["icon"].string))
                    case (today! + 2.days).day:
                        forecast[2].append(Forecast(temp_max: subJson["main"]["temp_max"].double! - 273,
                                                              temp_min: subJson["main"]["temp_min"].double! - 273,
                                                              day: subJson["dt_txt"].string?.toDate()?.weekdayName(.short),
                                                              icon: subJson["weather"][0]["icon"].string))
                    case (today! + 3.days).day:
                        forecast[3].append(Forecast(temp_max: subJson["main"]["temp_max"].double! - 273,
                                                             temp_min: subJson["main"]["temp_min"].double! - 273,
                                                             day: subJson["dt_txt"].string?.toDate()?.weekdayName(.short),
                                                             icon: subJson["weather"][0]["icon"].string))
                    case (today! + 4.days).day:
                        forecast[4].append(Forecast(temp_max: subJson["main"]["temp_max"].double! - 273,
                                                             temp_min: subJson["main"]["temp_min"].double! - 273,
                                                             day: subJson["dt_txt"].string?.toDate()?.weekdayName(.short),
                                                             icon: subJson["weather"][0]["icon"].string))
                    default:
                        print("")
                    }
                }
                
                completionHandler(forecast)
            }
            else {
                completionHandler(nil)
            }
        }
    }
}
