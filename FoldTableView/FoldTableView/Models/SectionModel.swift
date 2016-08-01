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
    
    class func loadData(finish: (models: [SectionModel]?) -> ()) {
        
        var array = [SectionModel]()
        for i in 0..<20 {
            let sectionModel = SectionModel()
            sectionModel.isExpanded = false
            sectionModel.sectionTitle = "第" + String(i + 1) + "组"
            var cellModels = [CellModel]()
            
            for j in 0..<10 {
                let cellModel = CellModel()
                cellModel.cellTitle = "第" + String(i + 1) + "组,第" + String(j + 1) + "行"
                cellModels.append(cellModel)
            }
            sectionModel.cellModels = cellModels
            array.append(sectionModel)
        }
        finish(models: array)
    }
}
