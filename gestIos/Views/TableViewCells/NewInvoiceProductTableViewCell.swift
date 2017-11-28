//
//  NewInvoiceProductTableViewCell.swift
//  gestIos
//
//  Created by MAC on 23/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit

class NewInvoiceProductTableViewCell: UITableViewCell {

    var product : Product? {
        didSet {
            updateProductInfo( )
        }
    }
    
    // Outlets
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var productIdLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    // End Outlets
    
    func updateProductInfo( ) {
        if let imageUrlString = product?.imageUrl {
            let photoUrl = URL(string: imageUrlString)
            productImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
            productNameLabel.text = "\(product!.name!)"
            productPriceLabel.text = "\(product!.price!)"
        }
    }

}
