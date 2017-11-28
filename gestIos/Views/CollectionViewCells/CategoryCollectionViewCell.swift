//
//  CategoryCollectionViewCell.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    var category : Category? {
        didSet {
            setupCategoryInfo( )
        }
    }
    @IBOutlet weak var categoryImageView: UIImageView!
    
    func setupCategoryInfo( ) {
        if let imageUrlString = category?.imageUrl {
            let imageUrl = URL(string : imageUrlString)
            categoryImageView.sd_setImage(with: imageUrl)
        }
    }
    
}
