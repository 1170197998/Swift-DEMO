//
//  ViewController.swift
//  SFLinkageTableView
//
//  Created by ShaoFeng on 16/7/22.
//  Copyright © 2016年 Cocav. All rights reserved.
//

import UIKit

var SCR_W = UIScreen.mainScreen().bounds.size.width
var SCR_H = UIScreen.mainScreen().bounds.size.height

class ViewController: UIViewController {

    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...20 {
            dataSource.append("第" + String(i) + "组")
        }
        view.addSubview(leftTableView)
        view.addSubview(rightTableView)
    }
    
    private lazy var leftTableView: UITableView = {
        let tableView = UITableView.init(frame: CGRectMake(0, 0, SCR_W * 0.25, SCR_H), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    private lazy var rightTableView: UITableView = {
        let tableView = UITableView.init(frame: CGRectMake(SCR_W * 0.3, 0, SCR_W * 0.7, SCR_H), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    //tableView中section的个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == leftTableView {
            return 1
        }
        return dataSource.count
    }
    
    //section中row的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            return dataSource.count
        }
        return 20
    }
    
    //header文字
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == leftTableView {
            return nil
        }
        return dataSource[section]
    }
    
    //返回每个cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let id = "id"
        var cell = tableView.dequeueReusableCellWithIdentifier(id)
        if (cell == nil) {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: id)
        }
        if tableView == leftTableView {
            cell?.textLabel?.text = dataSource[indexPath.row]
        } else {
            cell?.textLabel?.text = dataSource[indexPath.section] + "第" + String(indexPath.row + 1) + "行"
        }
        cell?.textLabel?.font = UIFont.systemFontOfSize(16)
        return cell!
    }
    
    //cell点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == rightTableView {
            return
        }
        rightTableView.selectRowAtIndexPath(NSIndexPath(forRow: 0,inSection: indexPath.row), animated: true, scrollPosition: UITableViewScrollPosition.Top)
    }
    
    //滑动停止时调用
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == leftTableView {
            return
        }
        leftTableView.selectRowAtIndexPath(NSIndexPath(forRow: (rightTableView.indexPathsForVisibleRows?.first?.section)!, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Middle)
    }
}
