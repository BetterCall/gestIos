//
//  StoreTableViewCell.swift
//  gestIos
//
//  Created by MAC on 03/12/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {

    var store : Store? {
        didSet {
            updateView( )
        }
    }
    
    @IBOutlet weak var storeNameLabel: UILabel!
    
    
    func updateView( ) {
        storeNameLabel.text =  store?.name
    }

}
