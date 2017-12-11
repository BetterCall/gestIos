//
//  CategoryFormViewController.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit

class CategoryFormViewController: UIViewController {

    // Variables
    
    
    // End Variable
    
    // Outlets

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var validateButton: UIButton!
    
    // End Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround() 

        // Block validation button until category has name
        //validateButton.isEnabled = false
        // Add gesture recognizer on category image view
        let categoryImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeCategoryImageAction) )
        categoryImageView.addGestureRecognizer(categoryImageViewTapGesture)
        categoryImageView.isUserInteractionEnabled = true
    }
    
    @objc func changeCategoryImageAction( ) {
        
        let pickerController = UIImagePickerController( )
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    // Actions
    
    @IBAction func validate_touchUpInside(_ sender: Any) {
        
        if let categoryImage = self.categoryImageView.image , let imageData = UIImageJPEGRepresentation(categoryImage, 0.1) {
     
            Api.Category.createCategory(name: nameTextField.text!, imageData : imageData,  onSuccess: {
            
                  _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    // End Actions

}

extension CategoryFormViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            categoryImageView.image = image
        }
        dismiss(animated: true, completion: nil )
    }
}

