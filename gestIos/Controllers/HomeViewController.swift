//
//  HomeViewController.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // Variables
    var categories = [Category]()
    // End Variables
    
    // Outlets
    @IBOutlet weak var newProductView: UIView!
    @IBOutlet weak var stockView: UIView!
    @IBOutlet weak var invoiceView: UIView!
   
    @IBOutlet var goToStockGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet var goToInvoiceGestureRecognizer: UITapGestureRecognizer!
    
    // End Outlets
    
    // Actions
    @IBAction func goToScanerAction(_ sender: Any) {
        performSegue(withIdentifier: "goToScannerVC", sender: nil)
        
    }
    
    @IBAction func goToStockAction(_ sender: Any) {
        performSegue(withIdentifier: "goToStockVC", sender: nil)
    }
    
    @IBAction func goToInvoiceAction(_ sender: Any) {
        performSegue(withIdentifier: "goToInvoiceVC", sender: nil)
    }
    
    
    // End Actions
    override func viewDidLoad() {
        super.viewDidLoad()
     
        

        // Do any additional setup after loading the view.
    }

 
  
}
