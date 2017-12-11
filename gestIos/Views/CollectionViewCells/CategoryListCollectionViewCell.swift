//
//  CategoryListCollectionViewCell.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit


protocol CategoryListCollectionViewCellDelegate {
    func selectCategoryId( categoryId : String)
    //func goToProfileVC (userId : String )
}


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
    
    var delegate : CategoryListCollectionViewCellDelegate?
   
    func setupCategoryInfo( ) {
        if let imageUrlString = category?.imageUrl {
            let imageUrl = URL(string : imageUrlString)

            categoryImageView.sd_setImage(with: imageUrl! )
            nameLabel.text = category?.name
        }
        // add cell touch gesture recognizer
        let tapGestureForCell = UITapGestureRecognizer(target: self, action: #selector(self.cell_TouchUpInside))
        addGestureRecognizer(tapGestureForCell)
        isUserInteractionEnabled = true
        
    }
    
    @objc func cell_TouchUpInside( ) {
        if let id = category?.id {
            delegate?.selectCategoryId(categoryId: id)
        }
    }
    
}
