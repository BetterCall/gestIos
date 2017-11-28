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
    
    var invoice : [Product] = [] {
        didSet {
            updateTopView( )
        }
    }

    
    // Outlets

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var validateButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    // End Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        self.setupCamera()
        
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (captureSession.isRunning == false) {
            captureSession.startRunning();
        }
        
    }
    
    /**
    *
    * Update information inside top view
    *
    **/
    func updateTopView( ) {
        var total = 0
        for product in invoice {
            guard let price = product.price else {
                return
            }
            total += price
        }
        
        totalLabel.text = "\(total)"
        productCountLabel.text = "\(invoice.count)"
        
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
            self.invoice.insert(product, at: 0 )
            self.tableView.reloadData()
            print("PRODUCT FOUND")
            
            let alert = UIAlertController(title: "Suivant", message: "\(product.name) - \(product.price) ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Suivant", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } , onError: { boolean in
            // Product does not exist need to be created
              print("PRODUCT NOT FOUND")
        })
    }
}


extension NewInvoiceViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoice.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewInvoiceProductTableViewCell", for: indexPath) as! NewInvoiceProductTableViewCell
            
            let index = indexPath.row
            
            cell.product = invoice[index]
        
            //cell.delegate = self
            
            return cell
    }
    
    
}



