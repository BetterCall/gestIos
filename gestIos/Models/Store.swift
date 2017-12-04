//
//  Product.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import Foundation

class Store {
    var id : String?
    var name : String?
    var address : String?
    var postalCode : String?
    var city : String?
}

extension Store  {
    
    static func create (data: [String: Any], key: String) -> Store  {
        
        let store = Store()
        store.id = key
        store.name = data["name"] as? String
        store.address = data["address"] as? String
        store.postalCode = data["postalCode"] as? String
        store.city = data["city"] as? String
    
        return store
    }
    
}

