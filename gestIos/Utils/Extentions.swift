//
//  Extentions.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
