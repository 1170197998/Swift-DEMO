//
//  SectionModel.swift
//  FoldTableView
//
//  Created by ShaoFeng on 16/7/29.
//  Copyright © 2016年 Cocav. All rights reserved.
//

import UIKit

class SectionModel: NSObject {

    var sectionTitle: String? = nil
    var isExpanded: Bool? = false
    var cellModels: [CellModel] = []
}
