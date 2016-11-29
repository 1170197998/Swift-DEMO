//
//  ViewController.swift
//  TableViewSlideMultiButton
//
//  Created by ShaoFeng on 16/7/26.
//  Copyright © 2016年 Cocav. All rights reserved.
//
//http://g.recordit.co/FKfm1AI436.gif
import UIKit

class ViewController: UIViewController {

    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = ["联想","华为","苹果","三星","小米","锤子","OPPO","诺基亚","一加","格力"]
        view.addSubview(tableView)
        tableView.frame = UIScreen.main.bounds
    }
    
    fileprivate lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}

extension ViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "id")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "id")
        }
        cell?.textLabel?.text = dataSource[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    /**
     提交编辑结果
     */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    /**
     返回按钮数组
     */
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction.init(style: UITableViewRowActionStyle.normal, title: "删除") { (action, indexPath) in
            print("点击了删除")
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.none)
        }
        deleteAction.backgroundColor = UIColor.red
        
        let moreAction = UITableViewRowAction.init(style: UITableViewRowActionStyle.normal, title: "更多") { (action, indexPath) in
            print("点击了更多")
            tableView.reloadData()
        }
        moreAction.backgroundColor = UIColor.orange

        let topAction = UITableViewRowAction.init(style: UITableViewRowActionStyle.normal, title: "置顶") { (action, indexPath) in
            print("点击了置顶")
            self.dataSource.insert(self.dataSource[indexPath.row], at: 0)
            self.dataSource.remove(at: indexPath.row + 1)
            self.tableView.reloadData()
        }
        
        return [deleteAction,moreAction,topAction]
    }
}
