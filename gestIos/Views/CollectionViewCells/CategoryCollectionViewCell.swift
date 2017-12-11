//
//  CategoryCollectionViewCell.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit

protocol CategoryCollectionViewCellDelegate {
    func selectCategoryId( categoryId : String , action : Bool )
    //func goToProfileVC (userId : String )
}


class CategoryCollectionViewCell: UICollectionViewCell {
    
    var category : Category? {
        didSet {
            setupCategoryInfo( )
        }
    }
    var delegate : CategoryCollectionViewCellDelegate?
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var selectedView: UIView!
    
    func setupCategoryInfo( ) {
        if let imageUrlString = category?.imageUrl {
            let imageUrl = URL(string : imageUrlString)
            categoryImageView.sd_setImage(with: imageUrl)
        }
        // add cell touch gesture recognizer
        let tapGestureForCell = UITapGestureRecognizer(target: self, action: #selector(self.cell_TouchUpInside))
        addGestureRecognizer(tapGestureForCell)
        isUserInteractionEnabled = true
        
    }
    
    @objc func cell_TouchUpInside( ) {
        if selectedView.backgroundColor == UIColor.blue {
            selectedView.backgroundColor = UIColor.white
            if let id = category?.id {
                delegate?.selectCategoryId(categoryId: id, action : false)
            }
        } else {
        
            selectedView.backgroundColor = UIColor.blue
            if let id = category?.id {
                delegate?.selectCategoryId(categoryId: id, action : true )
            }
        }
       
    }
    
}
