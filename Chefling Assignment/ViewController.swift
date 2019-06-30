//
//  ViewController.swift
//  Chefling Assignment
//
//  Created by GAURAV NAYAK on 27/06/19.
//  Copyright © 2019 GAURAV NAYAK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentMaxTempLabel: UILabel!
    @IBOutlet weak var currentMinTempLabel: UILabel!
    @IBOutlet weak var currentDescLabel: UILabel!
    
    @IBOutlet weak var forecastImage0: UIImageView!
    @IBOutlet weak var forecastImage1: UIImageView!
    @IBOutlet weak var forecastImage2: UIImageView!
    @IBOutlet weak var forecastImage3: UIImageView!
    @IBOutlet weak var forecastImage4: UIImageView!
    
    @IBOutlet weak var forecastMMLabel0: UILabel!
    @IBOutlet weak var forecastMMLabel1: UILabel!
    @IBOutlet weak var forecastMMLabel2: UILabel!
    @IBOutlet weak var forecastMMLabel3: UILabel!
    @IBOutlet weak var forecastMMLabel4: UILabel!
    
    @IBOutlet weak var forecastDayLabel0: UILabel!
    @IBOutlet weak var forecastDayLabel1: UILabel!
    @IBOutlet weak var forecastDayLabel2: UILabel!
    @IBOutlet weak var forecastDayLabel3: UILabel!
    @IBOutlet weak var forecastDayLabel4: UILabel!
    
    @IBAction func setCityAction(_ sender: Any) {
        self.performSegue(withIdentifier: "setLocation", sender: nil)
    }
    
    var currentWeather = Current()
    var forecast = Array(repeating: Array(repeating: Forecast(), count: 0), count: 5)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Swipe Down Gesture to reload
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)
        
        CoreDataModel.shared.showPreviousData() {
            (currentCD, forecastCD) in
            if currentCD != nil {
                self.forecast = forecastCD!
                self.currentWeather = currentCD!
                
                self.updateCurrentWeather()
                self.updateForecastUI(swap: 0)
                self.addToCoreData(swap: 0)
            }
        }
        
        if Connectivity.isConnectedToInternet() {

            CoreDataModel.shared.clear()
            self.callWeatherForecast()
            
            UserDefaults.standard.set("displayVC", forKey: "VC")
            Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(ViewController.updateEveryFive), userInfo: nil, repeats: true)
        }
        else {
            self.alertView(message: "No Internet, please check.")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.currentCityLabel.text = currentCity
        if Connectivity.isConnectedToInternet() {
            CoreDataModel.shared.clear()
            self.callWeatherForecast()
        }
        else {
            self.alertView(message: "No Internet, please check.")
        }
    }
    
    @objc func updateEveryFive() {
        self.callWeatherForecast()
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if Connectivity.isConnectedToInternet() {
            self.callWeatherForecast()
        }
        else {
            self.alertView(message: "No Internet, please check.")
        }
    }
    
    func callWeatherForecast() {
        OpenWeatherModel.shared.getWeather() {
            (result) in
            if result != nil {
                self.currentWeather = result!
                OpenWeatherModel.shared.getImage(icon: (result?.icon)!) {
                    (image) in
                    DispatchQueue.main.async {
                        self.currentImage.image = image
                        self.updateCurrentWeather()
                    }
                }
            }
            else {
                self.alertView(message: "City not found, check spelling.")
            }
        }
        OpenWeatherModel.shared.getForecast() {
            (result) in
            if result != nil {
                self.forecast = result!
                self.updateForecastUI(swap: 4)
                self.addToCoreData(swap: 4)
            }
        }
    }
    
    func updateCurrentWeather() {
        //Setup UIFields and update UserDefault
        self.currentCityLabel.text = currentCity
        self.currentTempLabel.text = String(Int(self.currentWeather.temp!)) + "°"
        self.currentMaxTempLabel.text = String(Int(self.currentWeather.temp_max!)) + "°"
        self.currentMinTempLabel.text = String(Int(self.currentWeather.temp_min!)) + "°"
        self.currentDescLabel.text = self.currentWeather.description
    }
    
    func updateForecastUI(swap: Int) {
        //Setup UIField and Call function to add to CoreData
        let forecastDayLabelArray = [forecastDayLabel0, forecastDayLabel1, forecastDayLabel2, forecastDayLabel3, forecastDayLabel4]
        let forecastMMLabelArray = [forecastMMLabel0, forecastMMLabel1, forecastMMLabel2, forecastMMLabel3, forecastMMLabel4]
        let forecastImageArray = [forecastImage0, forecastImage1, forecastImage2, forecastImage3, forecastImage4]
        
        for i in 0...4 {
            forecastMMLabelArray[i]?.text = String(Int(findMaximum(theArray: self.forecast[i]))) + "°/" + String(Int(findMinimum(theArray: self.forecast[i]))) + "°"
            forecastDayLabelArray[i]?.text = self.forecast[i][0].day
            if i == 0 {
                OpenWeatherModel.shared.getImage(icon: self.forecast[i][0].icon!) { (image) in forecastImageArray[i]!.image = image }
            }
            else {
                OpenWeatherModel.shared.getImage(icon: self.forecast[i][swap].icon!) { (image) in forecastImageArray[i]!.image = image }
            }
        }
    }
    
    func alertView(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            @unknown default:
                print("Other")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addToCoreData(swap: Int) {
        
        CoreDataModel.shared.addForecastCoreData(forecast_max: findMaximum(theArray: self.forecast[0]),
                                                 forecast_icon: self.forecast[0][0].icon!,
                                                 forecast_day: self.forecast[0][0].day!,
                                                 day: 0,
                                                 forecast_min: findMinimum(theArray: self.forecast[0]))
        
        for i in 1...4 {
            CoreDataModel.shared.addForecastCoreData(forecast_max: findMaximum(theArray: self.forecast[i]),
                                                     forecast_icon: self.forecast[i][swap].icon!,
                                                     forecast_day: self.forecast[i][0].day!,
                                                     day: i,
                                                     forecast_min: findMinimum(theArray: self.forecast[i]))
        }
    }

}


