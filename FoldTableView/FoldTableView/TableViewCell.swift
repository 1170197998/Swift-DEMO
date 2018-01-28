//
//  TableViewCell.swift
//  FoldTableView
//
//  Created by ShaoFeng on 2018/1/26.
//  Copyright © 2018年 Cocav. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    var _cellModel: CellModel?
    var cellModel: CellModel? {
        didSet {
            _cellModel = cellModel
            textLabel?.text = cellModel?.cellTitle
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}
