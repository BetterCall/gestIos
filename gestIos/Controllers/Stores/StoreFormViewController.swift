//
//  StoreFormViewController.swift
//  gestIos
//
//  Created by MAC on 03/12/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit

class StoreFormViewController: UIViewController {

    
    // Outlets

    @IBOutlet weak var storeNameTextField: UITextField!
    
    @IBOutlet weak var storeAdressTextField: UITextField!
    
    @IBOutlet weak var storeCityTextField: UITextField!

    @IBOutlet weak var storePostalCodeTextField: UITextField!
    
    // End Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()
        
        

        // Do any additional setup after loading the view.
    }

    
    @IBAction func validateBtn_TouchUpInside(_ sender: Any) {
        
        guard let name = storeNameTextField.text , name != "" else {
            return
        }
        guard let address = storeAdressTextField.text , address != "" else {
            return
        }
        guard let city = storeCityTextField.text , city != "" else {
            return
        }
        guard let postalCode = storePostalCodeTextField.text , postalCode != "" else {
            return
        }
        
        Api.Store.createStore(name: name, address: address, city: city, postalCode: postalCode, onSuccess: { storeId in 
                Api.Stock.createStoreStock( storeId : storeId )
            
            _ = self.navigationController?.popViewController(animated: true)

        })
        
        
    }
    
}
