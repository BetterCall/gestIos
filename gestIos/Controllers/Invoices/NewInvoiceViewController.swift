//
//  NewInvoiceViewController.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit
import AVFoundation

class NewInvoiceViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    let videoCaptureDevice = AVCaptureDevice.default(for: .video)
    let device = AVCaptureDevice.default(for: .video)
    //var videoCaptureDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    //var device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    var output = AVCaptureMetadataOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var captureSession = AVCaptureSession( )
    
    var products : [Product] = [] {
        didSet {
            updateTopView( )
        }
    }
    var total = 0

    // Outlets

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var productCountLabel: UILabel!

    
    @IBOutlet weak var bottomView: UIView!

    
    @IBOutlet weak var tableView: UITableView!
    // End Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        self.setupCamera()
        

        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (captureSession.isRunning == false) {
            captureSession.startRunning();
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (captureSession.isRunning == true) {
            captureSession.stopRunning();
        }
        
    }
    
    /**
    *
    * Update information inside top view
    *
    **/
    func updateTopView( ) {
        var tot = 0
        for product in products {
            guard let price = product.price else {
                return
            }
            tot += price
        }
        
        self.title = "Total : \(tot) €"
        self.total = tot
        productCountLabel.text = "\(products.count)"
        
    }
    
    private func setupCamera() {
        
        let input = try? AVCaptureDeviceInput(device: videoCaptureDevice!)
        
        if self.captureSession.canAddInput(input!) {
            self.captureSession.addInput(input!)
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        if let videoPreviewLayer = self.previewLayer {
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = self.view.bounds
            view.layer.addSublayer(videoPreviewLayer)
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if self.captureSession.canAddOutput(metadataOutput) {
            self.captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.ean13]
        } else {
            print("Could not add metadata output")
        }
        
        self.view.bringSubview(toFront: topView)
        self.view.bringSubview(toFront: bottomView)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        //func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // This is the delegate'smethod that is called when a code is readed
        for metadata in metadataObjects {
            let readableObject = metadata as! AVMetadataMachineReadableCodeObject
            let code = readableObject.stringValue
            print(code!)
            
            if (captureSession.isRunning == true) {
                captureSession.stopRunning()
                self.findProduct( id: code! )
            }
            
        }
    }
    
    func findProduct( id: String ) {
        Api.Product.observeProduct(withId: id, onSuccess: { product in
            //self.updateProductInfo(product: product)
         
            print("PRODUCT FOUND")
            
            let alert = UIAlertController(title: "\(product.name!) ", message: "\(product.price!) euros", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.cancel, handler:{ action in
                // whatever else you need to do here
                if (self.captureSession.isRunning == false) {
                    self.captureSession.startRunning();
                }
            }))
    
            alert.addAction(UIAlertAction(title: "Confirmer", style: UIAlertActionStyle.default, handler:{ action in
                // whatever else you need to do here
                self.products.insert(product, at: 0 )
                self.tableView.reloadData()
                
                if (self.captureSession.isRunning == false) {
                    self.captureSession.startRunning();
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
         

            
        } , onError: { boolean in
            // Product does not exist need to be created
              print("PRODUCT NOT FOUND")
        })
    }
    
    @IBAction func validate_TouchUpInside(_ sender: Any) {
        if (captureSession.isRunning == true) {
            captureSession.stopRunning();
        }

      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToPaiementVC") {
            print("1111")
            
            let controller = segue.destination as! CloseInvoiceViewController
            let invoice = Invoice.create(data: [ "products" : products , "total" : total ], key: "" )
            controller.invoice = invoice
            
            
        }
    }
    

    
}


extension NewInvoiceViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewInvoiceProductTableViewCell", for: indexPath) as! NewInvoiceProductTableViewCell
            
            let index = indexPath.row
            
            cell.product = products[index]
        
            //cell.delegate = self
            
            return cell
    }

}

extension NewInvoiceViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("sup row")
            self.products.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
}


