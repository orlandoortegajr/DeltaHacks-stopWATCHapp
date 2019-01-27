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
    
    //TODO: make sure location is being sent in the background
    //TODO: fix so that driverID gets passed on to this viewController
    var driverID = "12345"
    var locationManager: CLLocationManager?
    var parameters: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestAlwaysAuthorization()
        
        locationManager?.startUpdatingLocation()
        locationManager?.distanceFilter = 5
    }
    
    //confirms user accepted to be tracked
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways{
            //acceptance received
            print("User Accepted")
        } else {
            //acceptance not received
            print("Location not accepted")
            
            //TODO: Alert if user selects not allowed
        }
    }
    
    //updates user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for currentLocation in locations{
            print("New location is latitude: \(currentLocation.coordinate.latitude) and longitude: \(currentLocation.coordinate.longitude)")
            makeRequest(location: currentLocation)
        }
    }
    
    //makes server request, send server data
    func makeRequest(location: CLLocation){
        let urlString = "https://sigma-myth-229819.appspot.com/driverApi"
        
        parameters = ["driverID": driverID, "lat": String(location.coordinate.latitude), "lon": String(location.coordinate.longitude)]
        
        
        Alamofire.request(urlString, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
                
                //TODO: Alert user that location is being tracked
                
                break
                
            case .failure(let error):
                print(error)
                
                //TODO: Alert user that there was a communication error
            }
        }
    }
    
}
