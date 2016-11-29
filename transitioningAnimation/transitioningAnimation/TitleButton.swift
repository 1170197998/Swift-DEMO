//
//  TitleButton.swift
//  SFWeiBo
//
//  Created by mac on 16/3/26.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
       
       setImage(UIImage(named: "navigationbar_arrow_down"), for: UIControlState())
       setImage(UIImage(named: "navigationbar_arrow_up"), for: UIControlState.selected)
       setTitleColor(UIColor.darkGray, for: UIControlState())
       sizeToFit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.size.width
    }
}
