//
//  ProductTableViewCell.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit

protocol  ProductTableViewCellDelegate {
    func goToProductDetailVC ( product : Product )
}

class ProductTableViewCell: UITableViewCell {

    var delegate : ProductTableViewCellDelegate?
    var product : Product? {
        didSet {
            updateProductInfo( )
        }
    }
    var category : Category? {
        didSet {
            updateCategoryInfo( )
        }
    }
    // Outlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stockCountLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    // End Outlets
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateProductInfo( ) {
        if let imageUrlString = product?.imageUrl {
            let photoUrl = URL(string: imageUrlString)
            productImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
            nameLabel.text = "\(product!.name!)"
            stockCountLabel.text = "\(product!.stock!)"
        }
    }
    
    func updateCategoryInfo( ) {
        if let imageUrlString = category?.imageUrl {
            let photoUrl = URL(string: imageUrlString)
            categoryImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
    }
    

}
