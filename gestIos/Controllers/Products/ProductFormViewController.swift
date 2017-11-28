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
    
    // Outlets
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var validateButton: UIButton!
    
    // End Outlets
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        //validateButton.isEnabled = false ;
        
        let productImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeProductImageAction) ) 
        productImageView.addGestureRecognizer(productImageViewTapGesture)
        productImageView.isUserInteractionEnabled = true

        // Do any additional setup after loading the view.
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
            Api.Product.createProduct(key : productId! ,name: nameLabel.text!, price : price ,  imageData : imageData,  onSuccess: {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let categoryListVC = storyboard.instantiateViewController(withIdentifier: "CategoryListViewController") as! CategoryListViewController
                
                self.navigationController?.pushViewController(categoryListVC, animated: true)
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

