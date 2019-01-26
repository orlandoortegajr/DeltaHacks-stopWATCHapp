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
    
    
    @IBOutlet weak var truckIDTextField: UITextField!
    
    var truckID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        truckIDTextField.delegate = self
    }
    
    func makeRequest(truckID: String){
        let urlString = "https://stackoverflow.com/post"
        
        Alamofire.request(urlString, method: .post, parameters: ["truckID": truckID],encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
                
                //TODO: Confirm response in order to properly authenticate user
                self.performSegue(withIdentifier: "CorrectID", sender: self)
                
                break
                
            case .failure(let error):
                print(error)
                
                self.performSegue(withIdentifier: "IncorrectID", sender: self)
            }
        }
    }
    
    func authenticateTruck(){
        if let truckID = truckIDTextField.text {
            makeRequest(truckID: truckID)
        } else {
            print("Truck text field is empty")
        }
    }
    
    
    
    @IBAction func linkToTruckPressed(_ sender: Any) {
        authenticateTruck()
    }
    
    //keyboard closes when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
}
