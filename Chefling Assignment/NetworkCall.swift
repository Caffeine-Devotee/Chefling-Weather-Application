//
//  NetworkCall.swift
//  Chefling Assignment
//
//  Created by GAURAV NAYAK on 27/06/19.
//  Copyright © 2019 GAURAV NAYAK. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkController {
    
    func getRequest(urlString: String, location: String, completionHandler: @escaping (Bool, JSON) -> Void ) {
        
        let parameters = ["q": location, "appid": "f5e4be1312c97020a6f4a3d458d2e75a"]  as [String : Any]
        let headers: HTTPHeaders = ["Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==", "Accept": "application/json"]
        Alamofire.request(URL(string: urlString)!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            
            do {
                let json = try JSON(data: response.data!)

                if response.response!.statusCode >= 200 && response.response!.statusCode < 300 {
                    completionHandler(true, json)
                }
                else {
                    completionHandler(false, JSON.null)
                }
                
            } catch{
                print(error)
                completionHandler(false, JSON.null)
            }
        }
    }
    
    func downloadImage(url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
        Alamofire.request(url).responseJSON { response in
            let image = UIImage(data: response.data!)
            DispatchQueue.main.async {
                if image != nil {
                    completion(image)
                }
                else {
                    completion(UIImage(named: "image_unavailable"))
                }
            }
        }
    }
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
