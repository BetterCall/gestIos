//
//  Product.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import Foundation

class Product {
    var id : String?
    var name : String?
    var categoryId : String?
    var category : Category?
    var price : Int? 
    var stock : Int?
    var imageUrl : String?
    
}

extension Product {
    
    static func create (data: [String: Any], key: String) -> Product {
        
        let product = Product()
        product.id = key
        product.name = data["name"] as? String
        product.categoryId = data["categoryId"] as? String
        product.stock = data["stock"] as? Int
        product.price = data["price"] as? Int
        product.imageUrl = data["imageUrl"] as? String
        
        return product
    }
    
}
