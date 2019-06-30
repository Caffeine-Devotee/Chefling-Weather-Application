//
//  LocationViewController.swift
//  Chefling Assignment
//
//  Created by GAURAV NAYAK on 28/06/19.
//  Copyright © 2019 GAURAV NAYAK. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBAction func setButtonAction(_ sender: Any) {
        currentCity = self.locationTextField.text!
        UserDefaults.standard.set(currentCity, forKey: "City")
        self.performSegue(withIdentifier: "toDisplay", sender: nil)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.locationTextField.delegate = self
        
        let name = UserDefaults.standard.string(forKey: "VC") ?? "locationVC"
        if name == "locationVC" {
            self.backButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
