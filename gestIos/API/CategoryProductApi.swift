//
//  CategoryProductApi.swift
//  gestIos
//
//  Created by MAC on 11/12/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class CategoryProductApi  {
    var REF_CATEGORY_PRODUCT = Database.database().reference().child("category_product")
    
    func observeProduct( categoryId id : String , onSuccess : @escaping( Product ) -> Void ) {
            REF_CATEGORY_PRODUCT.child(id).observeSingleEvent(
                of: .value,
                with: {
                    snapshot in
                    
                    snapshot.children
                        .forEach({  s in
                            let child = s as! DataSnapshot
                            print(child)
                            
                            Api.Product.observeProductWithStock(withId: child.key, onSuccess: { product in
                                onSuccess(product)
                            }, onError: { value in
                                
                            })
                            
                        })
                    
                   
            })
    }
    
    func addProductToCategory( productId : String , categories : [String : Bool]) {
        for category in categories {
            REF_CATEGORY_PRODUCT.child(category.key).setValue([productId : true ] )
        }
    }
    
}
