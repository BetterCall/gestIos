//
//  EditProductViewController.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit

class ProductFormViewController : UIViewController {

    var productId : String?
    var categories = [Category]()
    var categoriesSelected = [String : Bool] ( )
    
    // Outlets
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var validateButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    // End Outlets
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        //validateButton.isEnabled = false ;
        
        collectionView.dataSource = self
    
        loadCategories( )
        
        
        let productImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeProductImageAction) ) 
        productImageView.addGestureRecognizer(productImageViewTapGesture)
        productImageView.isUserInteractionEnabled = true

        // Do any additional setup after loading the view.
    }
    
    func  loadCategories( )  {
        Api.Category.observeCategories(onSuccess: { category in
            self.categories.append(category)
            self.collectionView.reloadData()
        })
    }
    
    @objc func changeProductImageAction() {
        
        let pickerController = UIImagePickerController( )
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }

    
    // Actions
    
    @IBAction func Validate_touchUpInside(_ sender: Any) {
        
        if let productImage = self.productImageView.image , let imageData = UIImageJPEGRepresentation(productImage, 0.1) {
            
            let price : Int = Int(priceLabel.text!)!
            Api.Product.createProduct(key : productId! ,name: nameLabel.text!, price : price ,  imageData : imageData, categories : categoriesSelected, onSuccess: {
                
                 _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    
    // End Actions

}


extension ProductFormViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            productImageView.image = image
        }
        dismiss(animated: true, completion: nil )
    }
}


extension ProductFormViewController :UICollectionViewDataSource {
    
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

extension ProductFormViewController : CategoryCollectionViewCellDelegate {
  
    
    
    func selectCategoryId(categoryId: String ,  action: Bool ) {
        print("cclikeed")
        
        if categoriesSelected[categoryId] != nil  {
            categoriesSelected.removeValue(forKey: categoryId)
        } else {
            categoriesSelected[categoryId] = true
        }
        
        print(categoriesSelected)
    }
    
    /*
     let storyboard = UIStoryboard(name: "Home", bundle: nil)
     let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
     detailVC.user = user
     detailVC.post = post
     
     navigationController?.pushViewController(detailVC, animated: true)
     */
}




