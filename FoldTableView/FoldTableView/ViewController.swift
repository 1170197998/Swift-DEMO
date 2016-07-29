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
        
        view.addSubview(tableView)
        tableView.frame = UIScreen.mainScreen().bounds
    }
    
    lazy var dataSource: [SectionModel] = {
        
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
        return array
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource[section].isExpanded != nil) ? dataSource[section].cellModels.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("id") as? TableViewCell
        if cell == nil {
            cell = TableViewCell.init(style: UITableViewCellStyle.Value1, reuseIdentifier: "id")
        }
        
        cell?.cellModel = dataSource[indexPath.section].cellModels[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("id") as? HeaderView
        if headerView == nil {
            headerView = HeaderView.init(reuseIdentifier: "id")
        }
        headerView?.sectionModel = dataSource[section]
        headerView!.expandCallBack = {
            (isExpanded: Bool) -> Void in
            tableView.reloadSections(NSIndexSet.init(index: section), withRowAnimation: UITableViewRowAnimation.Fade)
        }
        return headerView!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
}

