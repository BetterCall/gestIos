//
//  CategoryListCollectionViewCell.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit

class CategoryListCollectionViewCell: UICollectionViewCell {
    
    // Outlets
     @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    // End Outlets
    
    var category : Category? {
        didSet {
            setupCategoryInfo( )
        }
    }
   
    func setupCategoryInfo( ) {
        if let imageUrlString = category?.imageUrl {
            let imageUrl = URL(string : imageUrlString)
            categoryImageView.sd_setImage(with: imageUrl)
            nameLabel.text = category?.name
        }
    }
    
}
