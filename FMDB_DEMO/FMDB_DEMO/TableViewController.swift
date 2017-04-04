//
//  ViewController.swift
//  FMDB_DEMO
//
//  Created by ShaoFeng on 2017/4/3.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var dataArray = Array<ListModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        DBManager.shareManager.openDB()
    }
    
    private func makeData() {
        for i in 0..<10 {
            let model = ListModel()
            model.personId = i
            model.name = "名称\(i)"
            model.isTop = false
            ListDAO.shareDAO.insertData(model: model)
        }
        dataArray = ListDAO.shareDAO.getDataList() 
        self.tableView.reloadData()
    }
    
    @IBAction func creatTable(_ sender: Any) {
        ListDAO.shareDAO.creatTable()
        dataArray = ListDAO.shareDAO.getDataList()
        if dataArray.count == 0 {
            makeData()
        }
    }
    
    @IBAction func dropTable(_ sender: Any) {
        ListDAO.shareDAO.dropTable()
        dataArray = ListDAO.shareDAO.getDataList()
        tableView.reloadData()
    }
}

extension TableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArray[indexPath.row] 
        var cell = tableView.dequeueReusableCell(withIdentifier: "ID");
        if !(cell != nil)  {
            cell = UITableViewCell(style: .default, reuseIdentifier: "ID")
        }
        cell?.textLabel?.text = "\(model.name) + isTop: \(model.isTop)"
        if model.isTop {
            cell?.backgroundColor = UIColor.lightGray
        } else {
            cell?.backgroundColor = UIColor.white
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let model = dataArray[indexPath.row] 
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            guard ListDAO.shareDAO.deleteDataOfDataList(personId: model.personId) else  {
                return
            }
            self.dataArray = ListDAO.shareDAO.getDataList() 
            self.tableView.reloadData()
            print("Delete")
        }
        let topAction = UITableViewRowAction(style: .normal, title: model.isTop ? "Cancel Top" : "Top") { (action, indexPath) in
            guard ListDAO.shareDAO.setTopWithPersonId(personId: model.personId, isTop: !model.isTop) else {
                return
            }
            self.dataArray = ListDAO.shareDAO.getDataList()
            self.tableView.reloadData()
            print("Top")
        }
        return [deleteAction,topAction]
    }
}
