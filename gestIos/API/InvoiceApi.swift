//
//  CategoryApi.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//


import Foundation
import Firebase
import FirebaseDatabase

import SwiftKeychainWrapper

class InvoiceApi  {
    var REF_INVOICE = Database.database().reference().child("invoices")
    
    func createInvoice ( invoice : Invoice , onSuccess : @escaping( )-> Void   ) {
        
        // get product id
        guard let products = invoice.products else {
            return
        }
        var productsId =  [String : Any] ( )
        for product in products {
            productsId[product.id!] = true
            if invoice.payment != "none" {
                print("not cancelled")
                
                let storeId : String = KeychainWrapper.standard.string(forKey: "storeSelectedId")!
                if storeId != ""  {
                       Api.Stock.decrementStock(storeId : storeId ,productId: product.id!, onSuccess: {product in }, onError: { error in })
                }
                
             
            }
            
        }
        
        // Get a key for a new Invoice
        let newInvoiceKey = REF_INVOICE.childByAutoId().key
        REF_INVOICE.child(newInvoiceKey).setValue([
            "productsId" : productsId ,
            "payment" : invoice.payment,
            "total" : invoice.total ,
            
            ])
        onSuccess( )
    }
    
    func observeInvoices(onSuccess: @escaping (Invoice) -> Void) {
        REF_INVOICE.observe(
            .childAdded,
            with : { (snapshot) in
                if let data = snapshot.value as? [String: Any] {
                    let invoice = Invoice.create(data: data, key: snapshot.key)
                    onSuccess(invoice)
                }
        })
    }
    
    func observeInvoice(withId id: String, onSuccess: @escaping (Invoice) -> Void) {
        REF_INVOICE.child(id).observeSingleEvent(
            of: .value,
            with: {
                snapshot in
                if let data = snapshot.value as? [String: Any] {
                    let invoice = Invoice.create(data: data, key: snapshot.key)
                    onSuccess(invoice)
                }
        })
    }
    
    
}

