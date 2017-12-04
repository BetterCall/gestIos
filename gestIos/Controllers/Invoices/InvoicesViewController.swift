//
//  InvoicesViewController.swift
//  gestIos
//
//  Created by MAC on 03/12/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit

class InvoicesViewController: UIViewController {

    var invoices = [Invoice]( )
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        loadInvoices( )
    }

    func loadInvoices( ) {
        Api.Invoice.observeInvoices(onSuccess: { invoice in
                self.invoices.insert(invoice, at: 0 )
            self.tableView.reloadData()
            })
    }

}



extension InvoicesViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceTableViewCell", for: indexPath) as! InvoiceTableViewCell
            
            let index = indexPath.row
            
            cell.invoice = invoices[index]
            
            //cell.delegate = self
            
            return cell
    }
    


}


