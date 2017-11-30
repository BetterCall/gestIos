//
//  Invoice.swift
//  gestIos
//
//  Created by MAC on 29/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//


import Foundation

class Invoice {
    
    var id : String?

    var products : [Product]?
    var payment : String?
    var state : String?
    
}

extension Invoice {
    
    static func create (data: [String: Any], key: String) -> Invoice {
        
        let invoice = Invoice()
        invoice.id = key
        
        invoice.products = data["products"] as? [Product]
        invoice.payment = data["payment"] as? String
        invoice.state = data["state"] as? String
        
        return invoice
    }
    
}
