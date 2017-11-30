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
                    let product = Product.create(data: data, key: snapshot.key)
                    onSuccess(product)
                }
        })
    }
    
    func observeProduct(withId id: String, onSuccess: @escaping (Product) -> Void , onError : @escaping( Bool ) -> Void ) {
        REF_PRODUCT.child(id).observeSingleEvent(
            of: .value,
            with: { snapshot in
                if snapshot.hasChildren() {
                    if let data = snapshot.value as? [String: Any] {
                        let product = Product.create(data: data, key: snapshot.key)
                        onSuccess(product)
                    } else {
                        onError(true)
                    }
                } else {
                    onError(true)
                }
                
        })
    }
    
    func decrementStock(productId: String, onSuccess: @escaping (Product) -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        let productRef = Api.Product.REF_PRODUCT.child(productId)
        productRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var product = currentData.value as? [String : AnyObject] {
                
                var stock = product["stock"] as? Int ?? 0
                //var likesCount = post["likesCount"] as? Int ?? 0
                stock -= 1
                product["stock"] = stock as AnyObject?
                
                currentData.value = product
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                onError(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let product = Product.create(data: dict, key: snapshot!.key)
                onSuccess(product)
            }
        }
    }
    
    func incrementStock(productId: String, onSuccess: @escaping (Product) -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        let productRef = Api.Product.REF_PRODUCT.child(productId)
        productRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var product = currentData.value as? [String : AnyObject] {
                
                var stock = product["stock"] as? Int ?? 0
                //var likesCount = post["likesCount"] as? Int ?? 0
                stock += 1
                product["stock"] = stock as AnyObject?
                
                currentData.value = product
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                onError(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let product = Product.create(data: dict, key: snapshot!.key)
                onSuccess(product)
            }
        }
    }
    
  
}

