//
//  ScanCodeController.swift
//  AlipayScanQRCode
//
//  Created by ShaoFeng on 2017/2/17.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

let kMargin = 35
let kBorderW = 140

import UIKit
import AVFoundation

class ScanCodeController: UIViewController {

    var scanView: UIView? = nil
    var scanImageView: UIImageView? = nil
    var session = AVCaptureSession()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetAnimatinon()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let maskView = UIView(frame: view.bounds)
        maskView.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.6)
        view.addSubview(maskView)
        setupScanView()
        scaning()
    }
    
    fileprivate func setupScanView() {
        let scanViewW = self.view.bounds.width - CGFloat(kMargin * 2)
        let scanViewH = self.view.bounds.width - CGFloat(kMargin * 2)
        scanView = UIView(frame: CGRect(x: CGFloat(kMargin), y: CGFloat(kBorderW), width: scanViewW, height: scanViewH))
        scanView?.backgroundColor = UIColor.clear
        view.addSubview(scanView!)
        
        scanImageView = UIImageView(image: UIImage.init(named: "sweep_bg_line.png"));
        let widthOrHeight: CGFloat = 18
        
        let topLeft = UIButton(frame: CGRect(x: 0, y: 0, width: widthOrHeight, height: widthOrHeight))
        topLeft.setImage(UIImage.init(named: "sweep_kuangupperleft.png"), for: .normal)
        scanView?.addSubview(topLeft)
        
        let topRight = UIButton(frame: CGRect(x: scanViewW - widthOrHeight, y: 0, width: widthOrHeight, height: widthOrHeight))
        topRight.setImage(UIImage.init(named: "sweep_kuangupperright.png"), for: .normal)
        scanView?.addSubview(topRight)

        let bottomLeft = UIButton(frame: CGRect(x: 0, y: scanViewH - widthOrHeight, width: widthOrHeight, height: widthOrHeight))
        bottomLeft.setImage(UIImage.init(named: "sweep_kuangdownleft.png"), for: .normal)
        scanView?.addSubview(bottomLeft)
        
        let bottomRight = UIButton(frame: CGRect(x: scanViewH - widthOrHeight, y: scanViewH - widthOrHeight, width: widthOrHeight, height: widthOrHeight))
        bottomRight.setImage(UIImage.init(named: "sweep_kuangdownright.png"), for: .normal)
        scanView?.addSubview(bottomRight)
    }
    
    fileprivate func scaning() {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput.init(device: device)
            let output = AVCaptureMetadataOutput()
            output.rectOfInterest = CGRect(x: 0.1, y: 0, width: 0.9, height: 1)
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            session.canSetSessionPreset(AVCaptureSessionPresetHigh)
            session.addInput(input)
            session.addOutput(output)

            //在上面三行之后写下面代码,不然报错如下:Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[AVCaptureMetadataOutput setMetadataObjectTypes:] Unsupported type found - use -availableMetadataObjectTypes'
            //http://stackoverflow.com/questions/31063846/avcapturemetadataoutput-setmetadataobjecttypes-unsupported-type-found
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]
            
            let layer = AVCaptureVideoPreviewLayer(session: session)
            layer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            layer?.frame = view.layer.bounds
            view.layer.insertSublayer(layer!, at: 0)
            
            session.startRunning()
            
        } catch let error as NSError  {
            print("errorInfo\(error.domain)")
        }
    }
    
    fileprivate func resetAnimatinon() {
        let anim = scanImageView?.layer.animation(forKey: "translationAnimation")
        if (anim != nil) {
            let pauseTime = scanImageView?.layer.timeOffset
            let beginTime = CACurrentMediaTime() - pauseTime!
            scanImageView?.layer.timeOffset = 0.0
            scanImageView?.layer.beginTime = beginTime
            scanImageView?.layer.speed = 1.5
        } else {
            
            let scanImageViewH = 241
            let scanViewH = view.bounds.width - CGFloat(kMargin) * 2
            let scanImageViewW = scanView?.bounds.width
            
            scanImageView?.frame = CGRect(x: 0, y: -scanImageViewH, width: Int(scanImageViewW!), height: scanImageViewH)
            let scanAnim = CABasicAnimation()
            scanAnim.keyPath = "transform.translation.y"
            scanAnim.byValue = [scanViewH]
            scanAnim.duration = 1.8
            scanAnim.repeatCount = MAXFLOAT
            scanImageView?.layer.add(scanAnim, forKey: "translationAnimation")
            scanView?.addSubview(scanImageView!)
        }
    }
}

extension ScanCodeController:AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects.count > 0 {
            session.stopRunning()
            let object = metadataObjects[0]
            guard let url = URL(string: (object as AnyObject).stringValue) else {
                return
            }
            if UIApplication.shared.canOpenURL(url) {
                _ = self.navigationController?.popViewController(animated: true)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
                print("扫描成功")
            } else {
                print("扫描失败")
            }
        }
    }
}
