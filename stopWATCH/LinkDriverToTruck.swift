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
    
    //Ask for what should happen if a wrong ID is entered
    
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
    
    func raiseDriverAuthenticationAlert(){
        let alert = UIAlertController(title: "Invalid Driver ID", message: "Driver ID was not entered, please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func raiseTruckAuthenticationAlert(){
        let alert = UIAlertController(title: "Invalid Truck ID", message: "Truck ID was not entered, please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func raiseConnectionErrorAlert(){
        let alert = UIAlertController(title: "Internet Connection Error", message: "Server could not be reached, please check your network connection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func makeRequest(driverID: String, truckID: String){
        let urlString = "https://sigma-myth-229819.appspot.com/link"
        parameters = ["driverID": driverID, "truckID": truckID]
        
        
        Alamofire.request(urlString, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success:
                
                print(response)
                self.performSegue(withIdentifier: "CorrectID", sender: self)
                
                break
                
            case .failure(let error):
                self.raiseConnectionErrorAlert()
                print(error)
            }
        }
    }
    
    func authenticateDriverAndTruck(){
        if driverIDTextField.text != ""{
            driverID = driverIDTextField.text!
            if truckIDTextField.text != ""{
                truckID = truckIDTextField.text!
            
                makeRequest(driverID: driverID, truckID: truckID)
            } else {
                raiseTruckAuthenticationAlert()
            }
        } else {
            raiseDriverAuthenticationAlert()
        }
    }
    
    
    
    @IBAction func linkToTruckPressed(_ sender: Any) {
        authenticateDriverAndTruck()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CorrectIDViewController
        driverID = driverIDTextField.text!
        vc.driverID = self.driverID
    }
    
    //keyboard closes when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
}
