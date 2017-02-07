//
//  ViewController.swift
//  SFLinkageTableView
//
//  Created by ShaoFeng on 16/7/22.
//  Copyright © 2016年 Cocav. All rights reserved.
//

import UIKit

var SCR_W = UIScreen.main.bounds.size.width
var SCR_H = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
    
    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...30 {
            dataSource.append("第" + String(i) + "组")
        }
        view.addSubview(leftTableView)
        view.addSubview(rightTableView)
    }
    //fileprivate:文件私有
    //private:真正的私有,离开了这个类就无法访问
    fileprivate lazy var leftTableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCR_W * 0.25, height: SCR_H), style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    fileprivate lazy var rightTableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: SCR_W * 0.3, y: 0, width: SCR_W * 0.7, height: SCR_H), style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    //tableView中section的个数
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == leftTableView {
            return 1
        }
        return dataSource.count
    }
    
    //section中row的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            return dataSource.count
        }
        return 20
    }
    
    //header文字
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == leftTableView {
            return nil
        }
        return dataSource[section]
    }
    
    //返回每个cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "id"
        var cell = tableView.dequeueReusableCell(withIdentifier: id)
        if (cell == nil) {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: id)
        }
        if tableView == leftTableView {
            cell?.textLabel?.text = dataSource[indexPath.row]
        } else {
            cell?.textLabel?.text = dataSource[indexPath.section] + "第" + String(indexPath.row + 1) + "行"
        }
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 16)
        return cell!
    }
    
    //cell点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == rightTableView {
            return
        }
        rightTableView.selectRow(at: IndexPath(row: 0,section: indexPath.row), animated: true, scrollPosition: UITableViewScrollPosition.top)
    }
    
    //滑动停止时调用
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == leftTableView {
            return
        }
        leftTableView.selectRow(at: IndexPath(row: (rightTableView.indexPathsForVisibleRows?.first?.section)!, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.middle)
    }
}
