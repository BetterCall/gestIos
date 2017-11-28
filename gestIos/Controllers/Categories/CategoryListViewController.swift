//
//  CategoryListViewController.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit

class CategoryListViewController: UIViewController {

    // Variables
    var categories = [Category]( )
    
    // End Variables
    
    // Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // End Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        loadCategories( )
    }
    
    func loadCategories( ) {
        Api.Category.observeCategories(onSuccess: { category in
            
            self.categories.insert(category, at: 0)
            self.collectionView.reloadData( )
            
        })
    }
}



extension CategoryListViewController :UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryListCollectionViewCell", for: indexPath) as! CategoryListCollectionViewCell
        
        let index = indexPath.row
        cell.category = categories[index]
      
        return cell
    }
}










