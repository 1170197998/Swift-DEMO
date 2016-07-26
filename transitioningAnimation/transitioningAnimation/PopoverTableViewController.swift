//
//  PopoverTableViewController.swift
//  转场动画
//
//  Created by ShaoFeng on 16/4/26.
//  Copyright © 2016年 Cocav. All rights reserved.
//

import UIKit

//点击小菜单通知大列表数据刷新
let dataSourceChange = "dataSourceChange"

class PopoverTableViewController: UITableViewController {

    let PopoverAnimatorWillShow = "PopoverAnimatorWillShow"

    var arrayList = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayList = ["1","2","3","4","5","6","7"]
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:"cell")
        }
        cell?.textLabel?.text = (arrayList.objectAtIndex(indexPath.row) as! String)
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        NSNotificationCenter.defaultCenter().postNotificationName(dataSourceChange, object: nil, userInfo: ["key":indexPath.row])
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
