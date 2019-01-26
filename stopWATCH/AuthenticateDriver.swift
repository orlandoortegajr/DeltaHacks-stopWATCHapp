//
//  ViewController.swift
//  stopWATCH
//
//  Created by Orlando Ortega on 2019-01-26.
//  Copyright © 2019 Orlando Ortega. All rights reserved.
//

import UIKit
import Alamofire

class AuthenticateDriverViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var DriverIDField: UITextField!
    
    public var driverID = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DriverIDField.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //user pressed login
    @IBAction func LoginPressed(_ sender: UIButton) {
        authenticate()
    }
    
    private func authenticate(){
        
        if let driverID = DriverIDField.text {
            
            serverRequest(driverID: driverID)
            
        } else {
           print("Driver Field is empty")
        }
        
        
    }
    
    //makes request to server in order to confirm Driver has valid ID
    func makeRequest(driverID: String){
        let urlString = "https://stackoverflow.com/post"
        
        Alamofire.request(urlString, method: .post, parameters: ["driverID": driverID],encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
                case .success:
                    print(response)
                    
                    //TODO: Confirm response in order to properly authenticate user
                    self.performSegue(withIdentifier: "TruckLink", sender: self)
                    
                    break
                
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    func serverRequest(driverID: String){
        makeRequest(driverID: driverID)
    }

    
    //keyboard closes when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

