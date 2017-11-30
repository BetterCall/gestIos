//
//  CloseInvoiceViewController.swift
//  gestIos
//
//  Created by MAC on 29/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit

class CloseInvoiceViewController: UIViewController {

    // Variables
    var invoice : Invoice?
    var products : [Product]?
    
    // End Variables
    // Outlets
    @IBOutlet var cashPaymentGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var cardPaymentGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var checkPaymentGestureRecognizer: UITapGestureRecognizer!
    
    // End Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(invoice)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cashPaymentAction(_ sender: Any) {
        self.invoice?.payment = "cash"
        self.invoice?.state = "validate"
        closeInvoice( )
    }
    
    @IBAction func cardPaymentAction(_ sender: Any) {
        self.invoice?.payment = "card"
        self.invoice?.state = "validate"
         closeInvoice( ) 
    }
    
    @IBAction func checkPaymentAction(_ sender: Any) {
        self.invoice?.payment = "check"
        self.invoice?.state = "validate"
         closeInvoice( )
    }
    
    @IBAction func cancelInvoice(_ sender: Any) {
        self.invoice?.payment = "none"
        self.invoice?.state = "cancel"
         closeInvoice( )
    }
    
    func closeInvoice( ) {
        Api.Invoice.createInvoice(invoice: invoice! , onSuccess: {
            print("Success")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            
            self.navigationController?.pushViewController(homeVC, animated: true)
        })
    }
    
}
