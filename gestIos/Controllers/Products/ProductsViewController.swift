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
    var categoriesSelected = [String : Bool]( )
    var store : Store? {
        didSet {
            self.title = store?.name
        }
    }
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // End Outlets
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        collectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        products.removeAll()
        loadProducts( )
        loadCategories( )
        loadStore( )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadProducts( ) {
        Api.Product.observeProductsWithStock( onSuccess : { product in
            //
            self.products.insert(product, at: 0)
            self.tableView.reloadData( )
            
          
            
        })
    }
    
    func loadCategories( ) {
        Api.Category.observeCategories(onSuccess: { category in
            self.categories.insert(category, at: 0)
            self.collectionView.reloadData( )
        })
    }

    func loadStore( ) {
        Api.Store.observeCurrentStore(onSuccess: { store in
            self.store = store
        }, onError: { error in
            self.title = "Aucun store selectionné"
        })
    }
    
    @IBAction func ChangeStore_TouchUpInside(_ sender: Any) {
     
        
        let storyboard = UIStoryboard(name: "Parameters", bundle: nil)
        let storesVC = storyboard.instantiateViewController(withIdentifier: "StoresViewController") as! StoresViewController
        
        navigationController?.pushViewController(storesVC, animated: true)
        
    }
    
    
}

extension ProductsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
            
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
        cell.delegate = self
        //cell.mediaImageView.image = UIImage(named: "facebook")
        //cell.post = post
        
        
        return cell
    }
    
}

extension ProductsViewController : CategoryCollectionViewCellDelegate {
    
    func selectCategoryId(categoryId: String , action : Bool) {
        print("cclikeed")
        
        if categoriesSelected.isEmpty{
            self.products.removeAll()
            self.tableView.reloadData()
        }
        
        // add product to list
        if action {
            Api.CategoryProduct.observeProduct(categoryId: categoryId, onSuccess: { product in
                self.products.append(product)
                self.tableView.reloadData()
                self.categoriesSelected[categoryId] = true
            })
            
        } else { // remove product to list
            
            var index = [Int]( )
            for (i , product )  in products.enumerated() {
                if product.categories?[categoryId] != nil {
                    index.insert(i, at: 0)
                    
                    self.categoriesSelected[categoryId] = nil
                }
            }
            for i in index{
                products.remove(at: i)
                self.tableView.reloadData()
            }
            
            if products.isEmpty {
                loadProducts()
            }
        }
        
       
        
      
    }
        
        /*
         let storyboard = UIStoryboard(name: "Home", bundle: nil)
         let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
         detailVC.user = user
         detailVC.post = post
         
         navigationController?.pushViewController(detailVC, animated: true)
         */
}
    



