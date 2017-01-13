//
//  ViewController.swift
//  SearchHelight
//
//  Created by ShaoFeng on 2017/1/13.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

fileprivate let identifer = "identifier"
import UIKit

class ViewController: UIViewController {

    fileprivate var dataSource: NSMutableArray?
    fileprivate var dataResult: Array<String>?
    fileprivate var searchController: UISearchController = UISearchController()
    fileprivate var tableView: UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = ["北京海淀","上海虹桥","798艺术区","广州深圳","shanghai","内蒙古大草原","河北石家庄","湖南长沙","海南三亚","湖北武汉","陕西西安火车站"]
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: identifer)
        
        searchController = UISearchController.init(searchResultsController: nil)
        searchController.searchBar.frame = CGRect(x: 0, y: 44, width: 0, height: 44)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.showsCancelButton = true
        searchController.searchResultsUpdater = self
        searchController.isActive = true
        tableView?.tableHeaderView = searchController.searchBar
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return self.dataResult?.count ?? 0
        }
        return self.dataSource!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifer, for: indexPath)
        
        if searchController.isActive {
            let originResult = dataResult?[indexPath.row]
            let range = (originResult?.range(of: searchController.searchBar.text!) as? NSRange) ?? NSMakeRange(0, 0)
            let attributeString = NSMutableAttributedString(string: originResult ?? "")
            attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 18), range: range)
            attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: range)
            cell.textLabel?.attributedText = attributeString
            cell.textLabel?.text = dataResult?[indexPath.row]
        } else {
            cell.textLabel?.text = dataSource?.object(at: indexPath.row) as! String?
        }
        
        return cell
    }
}

extension ViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        dataResult = Array()
        let string = searchController.searchBar.text ?? ""
        let predicate = NSPredicate.init(format: "SELF CONTAINS [c] %@",string)
        dataResult = dataSource?.filtered(using: predicate) as! Array<String>?
        tableView?.reloadData()
    }
}
