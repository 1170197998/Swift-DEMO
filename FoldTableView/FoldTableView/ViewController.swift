//
//  ViewController.swift
//  FoldTableView
//
//  Created by ShaoFeng on 16/7/29.
//  Copyright © 2016年 Cocav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SectionModel.loadData { (models) in
            self.dataSource = models
        }
        view.addSubview(tableView)
        tableView.frame = UIScreen.main.bounds
    }
    
/// 为了减轻控制器负担,把请求数据放到了SectionModel模型中
//    lazy var dataSource: [SectionModel] = {
//        
//        var array = [SectionModel]()
//        for i in 0..<20 {
//            let sectionModel = SectionModel()
    //            secvarnModel.isExpanded = false
//            sectionModel.sectionTitle = "第" + String(i + 1) + "组"
//            var cellModels = [CellModel]()
//            
//            for j in 0..<10 {
//                let cellModel = CellModel()
//                cellModel.cellTitle = "第" + String(i + 1) + "组,第" + String(j + 1) + "行"
//                cellModels.append(cellModel)
//            }
//            sectionModel.cellModels = cellModels
//            array.append(sectionModel)
//        }
//        return array
//    }()
    
    /// 懒加载
    fileprivate lazy var dataSource: [SectionModel]? = nil
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (dataSource![section].isExpanded != false) ? dataSource![section].cellModels.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "id") as? TableViewCell
        if cell == nil {
            cell = TableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "id")
        }
        
        cell?.cellModel = dataSource![indexPath.section].cellModels[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "id") as? HeaderView
        if headerView == nil {
            headerView = HeaderView.init(reuseIdentifier: "id")
        }
        headerView?.sectionModel = dataSource![section]
        headerView!.expandCallBack = {
            (isExpanded: Bool) -> Void in
            tableView.reloadSections(NSIndexSet.init(index: section) as IndexSet, with: UITableViewRowAnimation.fade)
        }
        return headerView!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}

