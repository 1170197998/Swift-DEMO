//
//  DetailDAO.swift
//  FMDB_DEMO
//
//  Created by ShaoFeng on 2017/4/3.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

import UIKit

class DetailDAO: NSObject {

    static let shareDAO = DetailDAO()

    /// 创建表
    func creatTable() {
        // PRIMARY KEY: 设置主键后不会重复插入
        let sqlString = "CREATE TABLE IF NOT EXISTS TABLE_DETAIL ('desId' Integer PRIMARY KEY NOT NULL,'des' Text)"
        let sqlString1 = "CREATE INDEX IF NOT EXISTS INDEX_TABLE_DETAIL_desId ON TABLE_DETAIL(desId)"
        DBManager.shareManager.dbQueue?.inDatabase({ (db) in
            guard ((try? db?.executeUpdate(sqlString, values: [])) != nil),
                ((try? db?.executeUpdate(sqlString1, values: [])) != nil) else {
                return
            }
            print("数据表创建成功")
        })
    }
    
    /// 插入数据
    func insertData(model: DetailModel) {
        let sqlString = "INSERT OR REPLACE INTO TABLE_DETAIL(desId, des) values (?,?)"
        DBManager.shareManager.dbQueue?.inDatabase({ (db) in
            guard ((try? db?.executeUpdate(sqlString, values: [model.desId, model.des])) != nil) else {
                return
            }
            print("数据插入成功")
        })
    }
    
    /// 获取数据
    func getDataList() -> Array<Any> {
        
        var resultArray = Array<Any>()
        DBManager.shareManager.dbQueue?.inDatabase({ (db) in
            let sqlString = "SELECT * FROM TABLE_DETAIL"
            guard let set = try? db?.executeQuery(sqlString, values: []) else {
                return
            }
            while (set?.next())! {
                let model = DetailModel()
                model.desId = Int((set?.int(forColumn: "desId"))!)
                model.des = set?.string(forColumn: "des")
                resultArray.append(model)
            }
            set?.close()
        })
        return resultArray
    }
    
    /// 查询数据(全量获取)
    func getDataListWithString(string: String) -> Array<Any> {
        var resultArray = Array<Any>()
        DBManager.shareManager.dbQueue?.inDatabase({ (db) in
            // LIKE '%Java%'查询des字段中包含Java的, LIKE 'Java*' 查询以Java开头的, '*Java查询以Java结尾的'
            // 查询 TABLE_DETAIL 表中包含string的model
            let sqlString = "SELECT * FROM TABLE_DETAIL WHERE des LIKE '%" + string + "%'"
            guard let set = try? db?.executeQuery(sqlString, values: []) else {
                return
            }
            while (set?.next())! {
                let model = DetailModel()
                model.desId = Int((set?.int(forColumn: "desId"))!)
                model.des = set?.string(forColumn: "des")
                resultArray.append(model)
            }
            set?.close()
        })
        return resultArray
    }
    
    /// 分页获取数据(分页读取,每次20条)
    func pageReadDataListWith(page: Int) -> Array<Any> {
        var resultArray = Array<Any>()
        DBManager.shareManager.dbQueue?.inDatabase({ (db) in
            var sqlString = String()
            if page != 1 {
                // TABLE_DETAIL AS TD: 为TABLE_DETAIL起个别名TD
                // TD.desId>\(page * 20): 查询TD.desId大于当前的数据
                // ORDER BY TD.desId ASC: 根据TD.desId升序
                // LIMIT 0,20: 每次获取20条数据
                sqlString = "SELECT * FROM TABLE_DETAIL AS TD WHERE TD.desId>\(page * 20) ORDER BY TD.desId ASC LIMIT 0,20"
            } else {
                // ASC 升序(默认)  DESC 降序
                sqlString = "SELECT * FROM TABLE_DETAIL AS TD ORDER BY TD.desId ASC LIMIT 1,20"
            }
            guard let set = try? db?.executeQuery(sqlString, values: []) else {
                return
            }
            while (set?.next())! {
                let model = DetailModel()
                model.desId = Int((set?.int(forColumn: "desId"))!)
                model.des = set?.string(forColumn: "des")
                resultArray.append(model)
            }
            set?.close()
        })
        return resultArray
    }
}
