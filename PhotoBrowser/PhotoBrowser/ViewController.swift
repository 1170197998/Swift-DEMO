//
//  ViewController.swift
//  PhotoBrowser
//
//  Created by ShaoFeng on 14/04/2017.
//  Copyright © 2017 ShaoFeng. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var mArrayImages = Array<Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let margin = 10
        let width = (JK_ScreenWidth() - 40) / 3
        
        for index in 1..<10 {
            let imageName = "img\(index).jpg"
            let image = UIImage(named: imageName)
            let x = (CGFloat(margin) + width) * ((CGFloat(index) - 1).truncatingRemainder(dividingBy: 3) + 1) - width
            let y = 100 + ((Int(index) - 1) / 3) * (Int(margin) + Int(width))
            
            let imageView = UIImageView(frame: CGRect(x: x, y: CGFloat(y), width: width, height: width))
            imageView.backgroundColor = UIColor.gray
            imageView.image = image
            view.addSubview(imageView)
            
            let model = JKPhotoModel(imageView: imageView, smallPicUrl: imageName, cell: nil, contentView: view)
            mArrayImages.append(model!)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapImage))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tap)
            imageView.tag = index
        }
    }
    
    @objc private func tapImage(tap: UITapGestureRecognizer) {
        let imageView = tap.view
        JKPhotoBrowser().jk_itemArray = mArrayImages as! [JKPhotoModel]
        JKPhotoBrowser().jk_currentIndex = (imageView?.tag)! - 1
        JKPhotoBrowser().jk_showPageController = true
        JKPhotoManager.shared().jk_showPhotoBrowser()
        JKPhotoBrowser().jk_delegate = self
        JKPhotoBrowser().jk_QRCodeRecognizerEnable = true
    }
}

extension ViewController: JKPhotoManagerDelegate {
    func jk_handleQRCodeRecognitionResult(_ QRCodeContent: String) {
        JKPhotoBrowser().jk_hidesPhotoBrowserWhenPushed()
    }
}

