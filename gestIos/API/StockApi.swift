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

class StockApi  {
    var REF_STOCK = Database.database().reference().child("stocks")
    
    func observeStock(storeId : String , productId : String , onSuccess: @escaping (Int) -> Void) {
        REF_STOCK.child(storeId).child(productId).observe(
            .childAdded,
            with : { (snapshot) in
                print("snapshot \(snapshot.value)" )
                
                if let data = snapshot.value as? Int{
                    print(data )
                    onSuccess(data)
                }
        })
    }
    
    func observeInvoice(withId id: String, onSuccess: @escaping (Invoice) -> Void) {
        REF_STOCK.child(id).observeSingleEvent(
            of: .value,
            with: {
                snapshot in
                if let data = snapshot.value as? [String: Any] {
                    let invoice = Invoice.create(data: data, key: snapshot.key)
                    onSuccess(invoice)
                }
        })
    }
    
    
    func incrementStock(storeId : String , productId: String, onSuccess: @escaping (Int) -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        let storeProductRef = Api.Stock.REF_STOCK.child(storeId).child(productId)
       
        storeProductRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
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
                
                onSuccess(dict["stock"] as! Int)
            }
        }
    }
    
    func decrementStock(storeId : String , productId: String, onSuccess: @escaping (Int) -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        let storeProductRef = Api.Stock.REF_STOCK.child(storeId).child(productId)
        
        storeProductRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
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
                onSuccess(dict["stock"] as! Int)
            }
        }
    }
    
    
    
}


