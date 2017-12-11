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
    
    
    func createProduct ( key : String , name : String, price : Int , imageData : Data  , categories : [String : Bool ] , onSuccess : @escaping( )-> Void   ) {
        // Get a key for a new Category.
        StorageService.uploadDataToServer(folder: "products", imageData: imageData, onSuccess: {imageUrl in
            
            let product = [
                "name" : name ,
                "price" : price ,
                "imageUrl" : imageUrl ,
                "categories" : categories
                ] as [String : Any]
           
            self.REF_PRODUCT.child(key).setValue(product)
            Api.Stock.newProduct(productId: key)
            Api.CategoryProduct.addProductToCategory( productId : key , categories : categories)
        })
        
        onSuccess( )
    }
    
    func observeProductsWithStock(onSuccess: @escaping (Product) -> Void) {
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
    
    func observeProductsWithoutStock(onSuccess: @escaping (Product) -> Void) {
        REF_PRODUCT.observe(
            .childAdded,
            with : { (snapshot) in
                if let data = snapshot.value as? [String: Any] {
                    
                    var  product = Product.create(data: data, key: snapshot.key)
                     onSuccess( product )
                    
                }
        })
        
    }
    
    
    func observeProductWithStock(withId id: String, onSuccess: @escaping (Product) -> Void , onError : @escaping( Bool ) -> Void ) {
        REF_PRODUCT.child(id).observeSingleEvent(
            of: .value,
            with: { snapshot in
                if snapshot.hasChildren() {
                    if let data = snapshot.value as? [String: Any] {
                        let storeId : String = KeychainWrapper.standard.string(forKey: "storeSelectedId")!
                        if storeId != "" {
                            var  product = Product.create(data: data, key: snapshot.key)
                            
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
    
    func observeProductWithoutStock(withId id: String, onSuccess: @escaping (Product) -> Void , onError : @escaping( Bool ) -> Void ) {
        REF_PRODUCT.child(id).observeSingleEvent(
            of: .value,
            with: { snapshot in
                if snapshot.hasChildren() {
                    if let data = snapshot.value as? [String: Any] {
                        let storeId : String = KeychainWrapper.standard.string(forKey: "storeSelectedId")!
                        if storeId != "" {
                            var  product = Product.create(data: data, key: snapshot.key)
                            
                            onSuccess( product )
                        
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

