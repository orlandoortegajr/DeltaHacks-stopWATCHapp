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
    
    var driverID = ""
    var truckID = ""
    var locationManager: CLLocationManager?
    var parameters: [String: Any]?
    var buttonText = ""
    
    @IBOutlet weak var checkMarkImage: UIImageView!
    @IBOutlet weak var circleImage: UIImageView!
    
    @IBOutlet weak var truckIDTextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        locationManager?.startUpdatingLocation()
        locationManager!.allowsBackgroundLocationUpdates = true
        locationManager!.pausesLocationUpdatesAutomatically = false
        locationManager?.distanceFilter = 5
        
        buttonText = "Truck ID#: " + truckID
        
        truckIDTextButton.setTitle(buttonText, for: UIControl.State.normal)
        
        checkMarkImage.tintColor = .green
        circleImage.tintColor = .green1
        
    }
    
    func raiseLocationNotAcceptedAlert(){
        let alert = UIAlertController(title: "Location Services Required", message: "Application cannot run without location, please tap Settings and enable location", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func raiseConnectionErrorAlert(){
        let alert = UIAlertController(title: "Internet Connection Error", message: "Server could not be reached, please check your network connection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //confirms user accepted to be tracked
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways{
            //acceptance received
            print("User Accepted")
        } else {
            //acceptance not received
            print("Location not accepted")
            raiseLocationNotAcceptedAlert()
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
                
                break
                
            case .failure(let error):
                print(error)
                
                self.raiseConnectionErrorAlert()
            }
        }
    }
    
}
