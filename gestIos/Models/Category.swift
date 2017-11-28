//
//  Category.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import Foundation

class Category {
    var id : String?
    var name : String?
    var imageUrl : String?
}

extension Category {
    
    static func create (data: [String: Any], key: String) -> Category {
        
        let category = Category()
        category.id = key
        category.name = data["name"] as? String
        category.imageUrl = data["imageUrl"] as? String
        
        return category
    }
   
}
