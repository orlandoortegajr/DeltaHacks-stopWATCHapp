//
//  LinkDriverToTruck.swift
//  stopWATCH
//
//  Created by Orlando Ortega on 2019-01-26.
//  Copyright © 2019 Orlando Ortega. All rights reserved.
//

import UIKit
import Alamofire

class LinkDriverToTruckViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var driverIDTextField: UITextField!
    @IBOutlet weak var truckIDTextField: UITextField!
    
    var driverID = ""
    var truckID = ""
    var parameters: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        truckIDTextField.delegate = self
        driverIDTextField.delegate = self
    }
    
    func makeRequest(driverID: String, truckID: String){
        let urlString = "https://sigma-myth-229819.appspot.com/link"
        parameters = ["driverID": driverID, "truckID": truckID]
        
        
        Alamofire.request(urlString, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
                
                if let error = response.error{
                    print(error)
                    break
                } else {
                    //TODO: Confirm response in order to properly authenticate user
                    let vc = CorrectIDViewController()
                    vc.driverID = driverID
                    self.performSegue(withIdentifier: "CorrectID", sender: self)
                }
                
                break
                
            case .failure(let error):
                print(error)
                
                //TODO: Display error alert to user
            }
        }
    }
    
    func authenticateDriverAndTruck(){
        if let truckID = truckIDTextField.text {
            if let driverID = driverIDTextField.text{
                makeRequest(driverID: driverID, truckID: truckID)
            } else {
                print("Driver text field is empty")
            }
        } else {
            print("Truck text field is empty")
        }
    }
    
    
    
    @IBAction func linkToTruckPressed(_ sender: Any) {
        authenticateDriverAndTruck()
    }
    
    //keyboard closes when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
}
