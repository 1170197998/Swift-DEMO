//
//  ListDAO.swift
//  FMDB_DEMO
//
//  Created by ShaoFeng on 2017/4/3.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

import UIKit

class ListDAO: NSObject {
    
    /// 单例
    static let shareDAO = ListDAO()
    
    /// 创建表
    func creatTable() {
        let sqlString = "CREATE TABLE IF NOT EXISTS TABLE_LIST('personId' Integer, 'name' Text, 'isTop' Integer)"  //字段的单引号可有可没有
        DBManager.shareManager.dbQueue?.inDatabase({ (db) in
            guard (db?.executeUpdate(sqlString, withArgumentsIn: [])) != nil else {
                return
            }
            print("创表成功")
        })
    }
    
    /// 删除表
    func dropTable() {
        let sqlString = "DROP TABLE TABLE_LIST"
        DBManager.shareManager.dbQueue?.inDatabase({ (db) in
            guard (db?.executeUpdate(sqlString, withArgumentsIn: [])) != nil else {
                return
            }
            print("删除成功")
        })
    }
    
    /// 插入数据
    func insertData(model: ListModel) {
        let sqlString = "INSERT OR REPLACE INTO TABLE_LIST(personId, name, isTop) values (?,?,?)"
        DBManager.shareManager.dbQueue?.inDatabase({ (db) in
            guard (db?.executeUpdate(sqlString, withArgumentsIn: [model.personId, model.name, model.isTop]))! else {
                return
            }
            print("数据插入成功")
        })
    }
    
    /// 获取数据
    func getDataList() -> Array<ListModel> {
        var resultArray = Array<Any>()
        DBManager.shareManager.dbQueue?.inDatabase({ (db) in
            //无条件全量查找
            //let sqlString = "SELECT * FROM TABLE_LIST";
            //根据isTop字段降序输出
            let sqlString = "SELECT * FROM TABLE_LIST ORDER BY isTop DESC";
            guard let set = try? db?.executeQuery(sqlString, values: []) else {
                return
            }
            while (set?.next())! {
                let model = ListModel()
                model.personId = Int((set?.int(forColumn: "personId"))!)
                model.name = set?.string(forColumn: "name")
                model.isTop = (set?.bool(forColumn: "isTop"))!
                resultArray.append(model)
            }
            set?.close()
        })
        return resultArray as! Array<ListModel>
    }
    
    /// 删除单条数据
    func deleteDataOfDataList(personId: Int) -> Bool {
        var result: Bool = false
        DBManager.shareManager.dbQueue?.inDatabase({ (db) in
            let sqlString = "DELETE FROM TABLE_LIST WHERE personId = ?"
            result = (db?.executeUpdate(sqlString, withArgumentsIn: [personId]))!
        })
        return result
    }
    
    /// 置顶操作
    func setTopWithPersonId(personId: Int, isTop: Bool) -> Bool {
        var result: Bool = false
        DBManager.shareManager.dbQueue?.inDatabase({ (db) in
            let sqlString = "UPDATE TABLE_LIST SET isTop = ? WHERE personId = ?"
            result = (db?.executeUpdate(sqlString, withArgumentsIn: [isTop,personId]))!
        })
        return result
    }
}
