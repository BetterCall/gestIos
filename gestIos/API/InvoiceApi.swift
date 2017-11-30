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

class InvoiceApi  {
    var REF_INVOICE = Database.database().reference().child("invoices")
    
    func createInvoice ( products : [Product] ,  payment : String  , onSuccess : @escaping( )-> Void   ) {
        // Get a key for a new Invoice
        let newInvoiceKey = REF_INVOICE.childByAutoId().key
        REF_INVOICE.child(newInvoiceKey).setValue([
            "products" : products ,
            "payment" : payment
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

