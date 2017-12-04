//
//  ProductApi.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//


import Foundation
import Firebase
import FirebaseDatabase

import SwiftKeychainWrapper

class ProductApi  {
    var REF_PRODUCT = Database.database().reference().child("products")
    
    
    func createProduct ( key : String , name : String, price : Int , imageData : Data  , onSuccess : @escaping( )-> Void   ) {
        // Get a key for a new Category.
        StorageService.uploadDataToServer(folder: "products", imageData: imageData, onSuccess: {imageUrl in
           
            self.REF_PRODUCT.child(key).setValue([
                "name" : name ,
                "price" : price ,
                "imageUrl" : imageUrl
                ])
        })
        
        onSuccess( )
    }
    
    func observeProducts(onSuccess: @escaping (Product) -> Void) {
        REF_PRODUCT.observe(
            .childAdded,
            with : { (snapshot) in
                if let data = snapshot.value as? [String: Any] {
                    
                    let storeId : String = KeychainWrapper.standard.string(forKey: "storeSelectedId")!
                    if storeId != "" {
                        var  product = Product.create(data: data, key: snapshot.key)
                        
                        Api.Stock.observeStock(storeId: storeId, productId: product.id!, onSuccess: { stock in
                            product.stock = stock
                            onSuccess( product )
                            
                        })
                    }
                  
                    
                }
        })
                   
    }
    
    
    func observeProduct(withId id: String, onSuccess: @escaping (Product) -> Void , onError : @escaping( Bool ) -> Void ) {
        REF_PRODUCT.child(id).observeSingleEvent(
            of: .value,
            with: { snapshot in
                if snapshot.hasChildren() {
                    if let data = snapshot.value as? [String: Any] {
                        let storeId : String = KeychainWrapper.standard.string(forKey: "storeSelectedId")!
                        if storeId != "" {
                            let  product = Product.create(data: data, key: snapshot.key)
                            
                            Api.Stock.observeStock(storeId: storeId, productId: product.id!, onSuccess: { stock in
                                product.stock = stock
                                onSuccess( product )
                                
                            })
                        }
                    } else {
                        onError(true)
                    }
                } else {
                    onError(true)
                }
                
        })
    }
    

    
  
  
}

