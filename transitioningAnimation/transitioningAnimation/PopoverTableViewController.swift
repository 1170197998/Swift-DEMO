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

    var arrayList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayList = ["1","2","3","4","5","6","7"]
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"cell")
        }
        cell?.textLabel?.text = arrayList[indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        NotificationCenter.default.post(name: Notification.Name(rawValue: dataSourceChange), object: nil, userInfo: ["key":indexPath.row])
        dismiss(animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
