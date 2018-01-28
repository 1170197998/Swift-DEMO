//
//  HeaderView.swift
//  FoldTableView
//
//  Created by ShaoFeng on 2018/1/27.
//  Copyright © 2018年 Cocav. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    
    var sectionModel: SectionModel? {
        didSet {
            textLabel?.text = sectionModel?.sectionTitle
            if (sectionModel?.isExpanded)! {
                directionImage?.transform = CGAffineTransform.identity
            } else {
                directionImage?.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi))
            }
            if (sectionModel?.isExpanded)! {
                
            }
        }
    }
    
    var expandCallBack: (Bool) -> Void = { isExpanded in
        
    }
    
    /// 给闭包起别名
//    typealias Block = (Bool) -> Void
//    var expandCallBack1: Block = { isExpand in
//    }
    
    var directionImage: UIImageView? = nil
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let w = UIScreen.main.bounds.width
        directionImage = UIImageView.init(image: UIImage.init(named: "expanded"))
        directionImage?.frame = CGRect(x: w - 30, y: (44 - 8) / 2, width: 15, height: 8)
        contentView.addSubview(directionImage!)
        
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: 0, y: 0, width: w, height: 44)
        button.addTarget(self, action: #selector(onExpand(onExpand:)), for: .touchUpInside)
        contentView.addSubview(button)
        
        let line = UIView.init(frame: CGRect(x: 0, y: 44 - 0.5, width: w, height: 0.5))
        line.backgroundColor = UIColor.lightGray
        contentView.addSubview(line)
    }
    
    
    @objc func onExpand(onExpand: UIButton) {
        sectionModel?.isExpanded = !(sectionModel?.isExpanded)!
        
//        if (sectionModel?.isExpanded)! {
//            directionImage?.transform = CGAffineTransform.identity
//        } else {
//            directionImage?.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi))
//        }
        
        expandCallBack((sectionModel?.isExpanded)!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
