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

import SwiftKeychainWrapper

class StoreApi  {
    var REF_STORES = Database.database().reference().child("stores")
    
    func getStoreId ( ) -> String {
        return KeychainWrapper.standard.string(forKey: "storeSelectedId")!
    }
    func createCategory ( name : String,  imageData : Data  , onSuccess : @escaping( )-> Void   ) {
        // Get a key for a new Category.
        StorageService.uploadDataToServer(folder: "categories", imageData: imageData, onSuccess: {imageUrl in
            let  newCategoryKey = self.REF_STORES.childByAutoId().key
            self.REF_STORES.child(newCategoryKey).setValue([
                "name" : name ,
                "imageUrl" : imageUrl
                ])
        })
        
        onSuccess( )
    }
    
    func observeCurrentStore( onSuccess : @escaping (Store) -> Void , onError : @escaping (String) -> Void  ) {
        guard let storeSelectedId = KeychainWrapper.standard.string(forKey: "storeSelectedId") else {
             onError ("Store not selected")
            return
        }
        observeStore(withId: storeSelectedId, onSuccess: onSuccess )
    }
    
    func setCurrentStore( storeId id : String ) {
        let _: Bool = KeychainWrapper.standard.set(id, forKey: "storeSelectedId")
    }
    
    func observeStores(onSuccess: @escaping (Store) -> Void) {
        REF_STORES.observe(
            .childAdded,
            with : { (snapshot) in
                if let data = snapshot.value as? [String: Any] {
                    let store = Store.create(data: data, key: snapshot.key)
                    onSuccess(store)
                }
        })
    }
    
    func observeStore(withId id: String, onSuccess: @escaping (Store) -> Void) {
        REF_STORES.child(id).observeSingleEvent(
            of: .value,
            with: {
                snapshot in
                if let data = snapshot.value as? [String: Any] {
                    let store = Store.create(data: data, key: snapshot.key)
                    onSuccess(store)
                }
        })
    }
    
    
    
    
}

