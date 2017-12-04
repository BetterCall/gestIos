//
//  AddProductViewController.swift
//  gestIos
//
//  Created by MAC on 20/11/2017.
//  Copyright © 2017 Bryann. All rights reserved.
//

import UIKit
import AVFoundation

class ProductScanViewController: UIViewController , AVCaptureMetadataOutputObjectsDelegate {
    
    var product : Product?
    var store : Store? {
        didSet  {
            updateStoreView( )
        }
    }
    // Outlets
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var productDetailView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productStockLabel: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var storeNameLabel: UILabel!
    
    //@IBOutlet weak var continueButton: UIButton!
    
    // End Outlets
    
    
    let videoCaptureDevice = AVCaptureDevice.default(for: .video)
    let device = AVCaptureDevice.default(for: .video)
    //var videoCaptureDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    //var device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    var output = AVCaptureMetadataOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var captureSession = AVCaptureSession( )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSelectedStore ( )
        self.view.backgroundColor = UIColor.clear
        self.setupCamera()
        
        disableButtons()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if (captureSession.isRunning == false) {
            captureSession.startRunning();
        }
        //continueButton.isHidden = true
    }
    func   loadSelectedStore ( ) {
        Api.Store.observeCurrentStore(onSuccess: { store in
                self.store = store
            
        }, onError: { error in
            
        })
    }
    func updateStoreView () {
        storeNameLabel.text = store?.name
    }
    
    func  disableButtons( )  {
        cancelButton.isEnabled = false
        confirmButton.isEnabled = false
    }
    
    func enableButtons( ) {
        cancelButton.isEnabled = true
        confirmButton.isEnabled = true
    }
    
    func updateProductInfo( product : Product) {
        
        if let imageUrlString = product.imageUrl {
            let photoUrl = URL(string: imageUrlString)
            productImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
            //nameLabel.text = "\(product!.name!)"
            productNameLabel.text = product.name
            productStockLabel.text = "Stock : \(product.stock!)"
        }
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
        
        self.view.bringSubview(toFront: productDetailView)
        self.view.bringSubview(toFront: topView)
        //self.view.bringSubview(toFront: followButton)
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
                findProduct( id: code! )
            }
            
        }
    }
    
    func findProduct( id: String ) {
        Api.Product.observeProduct(withId: id, onSuccess: { product in
            self.product = product
            self.updateProductInfo(product: product)
            //self.continueButton.isHidden = false
            
            self.enableButtons()
            
        } , onError: { boolean in
            // Product does not exist need to be created
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let ProductFormVC = storyboard.instantiateViewController(withIdentifier: "ProductFormViewController") as! ProductFormViewController
            ProductFormVC.productId = id
           
            self.navigationController?.pushViewController(ProductFormVC, animated: true)
        })
    }
    
    // Actions
    @IBAction func confirmButton_touchUpInside(_ sender: Any) {
        
        if (captureSession.isRunning == false) {
            captureSession.startRunning();
            disableButtons()
        }
        
        guard let storeId = store?.id else {
            return
        }
        Api.Stock.incrementStock(
            storeId : storeId , 
            productId: (product?.id!)!,
            onSuccess: { stock in
                self.productStockLabel.text = "Stock : \(stock)"
            },
            onError: { error in })
       
        
    }
    
    @IBAction func cancelButton_touchUpInside(_ sender: Any) {
        
        if (captureSession.isRunning == false) {
            captureSession.startRunning();
            disableButtons()
        }
        
    }
    
    // End Actions
}










