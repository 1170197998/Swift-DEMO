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
        tableView.frame = UIScreen.mainScreen().bounds
    }
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}

extension ViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("id")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "id")
        }
        cell?.textLabel?.text = dataSource[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    /**
     提交编辑结果
     */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            dataSource.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    /**
     返回按钮数组
     */
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction.init(style: UITableViewRowActionStyle.Normal, title: "删除") { (action, indexPath) in
            print("点击了删除")
            self.dataSource.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        }
        deleteAction.backgroundColor = UIColor.redColor()
        
        let moreAction = UITableViewRowAction.init(style: UITableViewRowActionStyle.Normal, title: "更多") { (action, indexPath) in
            print("点击了更多")
            tableView.reloadData()
        }
        moreAction.backgroundColor = UIColor.orangeColor()

        let topAction = UITableViewRowAction.init(style: UITableViewRowActionStyle.Normal, title: "置顶") { (action, indexPath) in
            print("点击了置顶")
            self.dataSource.insert(self.dataSource[indexPath.row], atIndex: 0)
            self.dataSource.removeAtIndex(indexPath.row + 1)
            self.tableView.reloadData()
        }
        
        return [deleteAction,moreAction,topAction]
    }
}
