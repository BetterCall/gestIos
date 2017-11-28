//
//  ProductsViewController.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {
    
    var products =  [Product]( )
    var categories = [Category]( )
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // End Outlets
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        collectionView.dataSource = self
        

        // Get all product
        loadProducts( )
        loadCategories( )
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadProducts( ) {
        Api.Product.observeProducts( onSuccess : { product in
            //
            guard let categoryId = product.categoryId else {
                return
            }
            // Get product category with category id
            Api.Category.observeCategory(withId: categoryId, onSuccess: { cat in
                product.category = cat
                self.products.insert(product, at: 0)
                self.tableView.reloadData( )
            })
            
        })
    }
    
    func loadCategories( ) {
        Api.Category.observeCategories(onSuccess: { category in
            self.categories.insert(category, at: 0)
            self.collectionView.reloadData( )
        })
    }

}

extension ProductsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! ProductTableViewCell
            
            let index = indexPath.row
            let product = products[index]
            cell.product = product

            cell.delegate = self
            
            return cell
    }
}

extension ProductsViewController : ProductTableViewCellDelegate {
        
    func goToProductDetailVC ( product : Product ) {
            
    /*
         let storyboard = UIStoryboard(name: "Home", bundle: nil)
         let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
         detailVC.user = user
         detailVC.post = post
            
        navigationController?.pushViewController(detailVC, animated: true)
    */
    }
        
}


extension ProductsViewController :UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        let index = indexPath.row
        cell.category = categories[index]
        //cell.mediaImageView.image = UIImage(named: "facebook")
        //cell.post = post
        
        
        return cell
    }
    
}
    

