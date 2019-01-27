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
    
    //TODO: Check Credentials
    
    @IBOutlet weak var driverIDTextField: UITextField!
    @IBOutlet weak var truckIDTextField: UITextField!
    @IBOutlet weak var linkTruckButton: UIButton!
    
    var driverID = ""
    var truckID = ""
    var parameters: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        truckIDTextField.delegate = self
        driverIDTextField.delegate = self
        
        linkTruckButton.backgroundColor = UIColor.darkGray
        linkTruckButton.layer.cornerRadius = 17
        linkTruckButton.setTitleColor(UIColor.white, for: .normal)
        linkTruckButton.layer.opacity = 0.85
        linkTruckButton.layer.shadowColor = UIColor.black.cgColor
        linkTruckButton.layer.shadowRadius = 6
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
        truckID = truckIDTextField.text!
        vc.driverID = self.driverID
        vc.truckID = self.truckID
    }
    
    //keyboard closes when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
}
