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

class CategoryApi  {
    var REF_CATEGORY = Database.database().reference().child("categories")
    
    func createCategory ( name : String,  imageData : Data  , onSuccess : @escaping( )-> Void   ) {
        // Get a key for a new Category.
        StorageService.uploadDataToServer(folder: "categories", imageData: imageData, onSuccess: {imageUrl in
            let  newCategoryKey = self.REF_CATEGORY.childByAutoId().key
            self.REF_CATEGORY.child(newCategoryKey).setValue([
                "name" : name ,
                "imageUrl" : imageUrl
            ])
        })
    
        onSuccess( )
    }
    
    
    func observeCategories(onSuccess: @escaping (Category) -> Void) {
        REF_CATEGORY.observe(
            .childAdded,
            with : { (snapshot) in
                if let data = snapshot.value as? [String: Any] {
                    let category = Category.create(data: data, key: snapshot.key)
                    onSuccess(category)
                }
        })
    }
    
    func observeCategory(withId id: String, onSuccess: @escaping (Category) -> Void) {
        REF_CATEGORY.child(id).observeSingleEvent(
            of: .value,
            with: {
                snapshot in
                if let data = snapshot.value as? [String: Any] {
                    let category = Category.create(data: data, key: snapshot.key)
                    onSuccess(category)
                }
        })
    }
    
    
    

    
    
}
