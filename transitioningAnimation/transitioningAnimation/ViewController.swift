//
//  ViewController.swift
//  转场动画
//
//  Created by ShaoFeng on 16/4/26.
//  Copyright © 2016年 Cocav. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var array = [Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        let titleButton = TitleButton()
        titleButton.setTitle("点我 ", for: UIControlState())
        titleButton.addTarget(self, action: #selector(ViewController.clickButton), for: UIControlEvents.touchUpInside)
        navigationItem.titleView = titleButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.change), name: NSNotification.Name(rawValue: PopoverAnimatorWillShow), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.change), name: NSNotification.Name(rawValue: PopoverAnimatorWillDismiss), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.dataSource(_:)), name: NSNotification.Name(rawValue: dataSourceChange), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func dataSource(_ non: Notification) {
        array = [non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!]
//        print(array)
//        print(array.count)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cells")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cells")
        }
        if array.count != 0 {
            
            cell?.textLabel?.text = String(describing: array[indexPath.row])
        }

        return cell!
    }
    
    @objc func change() {
        
        let titleButton = navigationItem.titleView as! TitleButton
        titleButton.isSelected = !titleButton.isSelected
    }
    
    @objc func clickButton() {
        
        //弹出菜单
        let viewController = PopoverTableViewController()
        viewController.transitioningDelegate = popoverAnimator
        viewController.modalPresentationStyle = UIModalPresentationStyle.custom
        present(viewController, animated: true, completion: nil)
    }
    
    //懒加载转场
    fileprivate lazy var popoverAnimator: PopoverAnimator = {
        
        let pa = PopoverAnimator()
        //在这里设置弹出菜单的位置和大小
        pa.presentFrame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 100, y: 56, width: 200, height: 350)
        return pa
    }()
}
