//
//  StoresViewController.swift
//  gestIos
//
//  Created by MAC on 03/12/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit

class StoresViewController: UIViewController {

    // Variables
    var stores = [Store]( )
    // End Variables
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    // End Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        loadStores( )
        // Do any additional setup after loading the view.
    }
    
    func loadStores( ) {
        Api.Store.observeStores(onSuccess: { store in
            self.stores.append(store)
            self.tableView.reloadData( ) 
        })
    }
    
    

}


extension StoresViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell", for: indexPath) as! StoreTableViewCell
            
            let index = indexPath.row
            cell.store = stores[index]
            cell.detailTextLabel?.text = "choisir"
            //cell.delegate = self
            
            return cell
    }
    
}

extension StoresViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           Api.Store.setCurrentStore(storeId: stores[indexPath.row].id!)
        }
    }
    
  

}



