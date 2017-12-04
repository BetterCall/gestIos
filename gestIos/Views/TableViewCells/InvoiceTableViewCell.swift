//
//  InvoiceTableViewCell.swift
//  gestIos
//
//  Created by MAC on 03/12/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit

class InvoiceTableViewCell: UITableViewCell {

    @IBOutlet weak var invoiceIdLabel: UILabel!
    
    @IBOutlet weak var invoiceDateLabel: UILabel!
    
    var invoice : Invoice? {
        didSet {
            updateView()
        }
    }
    
    func updateView( ) {
        invoiceIdLabel.text = invoice?.id
        invoiceDateLabel.text = "12/12/12"
    }

}
