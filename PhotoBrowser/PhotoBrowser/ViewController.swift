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
        
        var mArray = Array<Any>()
        
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
            mArray.append(model!)
        }
        mArrayImages = mArray
    }
}

