//
//  StorageService.swift
//  gestIos
//
//  Created by MAC on 21/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//


import Foundation
import Firebase

class StorageService {
    
    // Store file
    static func uploadDataToServer( folder : String , imageData : Data ,  onSuccess : @escaping ( String ) -> Void ) {
        
        // create an unique key for image storage
        let imageIdString = NSUUID( ).uuidString
        
        let storageRef = Storage.storage().reference(forURL : Config.STORAGE_REF).child(folder).child(imageIdString)
        storageRef.putData(
            imageData,
            metadata: nil,
            completion: { ( metadata , error ) in
                if error != nil  {
                    return
                }
                let imageUrl = metadata?.downloadURL()?.absoluteString
                // return image url
                onSuccess(imageUrl!)
                //self.sendDataToDatabase(imageUrl : imageUrl! , onSuccess:  onSuccess)
                
        })
        
    }
    
  
}
