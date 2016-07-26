//
//  ViewController.swift
//  转场动画
//
//  Created by ShaoFeng on 16/4/26.
//  Copyright © 2016年 Cocav. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var array = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        let titleButton = TitleButton()
        titleButton.setTitle("锋少 ", forState: UIControlState.Normal)
        titleButton.addTarget(self, action: #selector(ViewController.clickButton), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleButton
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.change), name: PopoverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.change), name: PopoverAnimatorWillDismiss, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.dataSource(_:)), name: dataSourceChange, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func dataSource(non: NSNotification) {
        array = [non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!,non.userInfo!["key"]!]
//        print(array)
//        print(array.count)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cells")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cells")
        }
        if array.count != 0 {
            cell?.textLabel?.text = String(array.objectAtIndex(indexPath.row))
        }

        return cell!
    }
    
    func change() {
        
        let titleButton = navigationItem.titleView as! TitleButton
        titleButton.selected = !titleButton.selected
    }
    
    func clickButton() {
        
        //弹出菜单
        let viewController = PopoverTableViewController()
        viewController.transitioningDelegate = popoverAnimator
        viewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    //懒加载转场
    private lazy var popoverAnimator: PopoverAnimator = {
        
        let pa = PopoverAnimator()
        //在这里设置弹出菜单的位置和大小
        pa.presentFrame = CGRectMake(UIScreen.mainScreen().bounds.size.width / 2 - 100, 56, 200, 350)
        return pa
    }()
}
