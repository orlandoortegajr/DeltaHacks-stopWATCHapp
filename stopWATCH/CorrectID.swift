//
//  CorrectID.swift
//  stopWATCH
//
//  Created by Orlando Ortega on 2019-01-26.
//  Copyright © 2019 Orlando Ortega. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class CorrectIDViewController: UIViewController, CLLocationManagerDelegate {
    
    var driverID: String?
    var locationManager: CLLocationManager?
    var parameters: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestAlwaysAuthorization()
        
        locationManager?.startUpdatingLocation()
        locationManager?.distanceFilter = 4
    }
    
    //confirms user accepted to be tracked
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways{
            //acceptance received
            print("User Accepted")
        } else {
            //acceptance not received
            print("Location not accepted")
        }
    }
    
    //updates user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for currentLocation in locations{
            print("New location is \(locations)")
            makeRequest(location: currentLocation)
        }
    }
    
    func makeRequest(location: CLLocation){
        let urlString = "https://sigma-myth-229819.appspot.com/link"
        if let driverID = driverID {
            parameters = ["driverID": driverID, "lat": location.coordinate.latitude, "lon": location.coordinate.longitude]
        } else {
            print("Invalid driverID")
        }
        
        
        Alamofire.request(urlString, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
                
                //TODO: Confirm response in order to properly authenticate user
                
                
                break
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
}
