//
//  DBManager.swift
//  FMDB_DEMO
//
//  Created by ShaoFeng on 2017/4/3.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

import Foundation
import FMDB

class DBManager: NSObject {
    
    static let shareManager = DBManager()
    var dbQueue: FMDatabaseQueue?
    func openDB() {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let userPath = documentDirectory?.stringByAppendingPathComponent(path: "data10001")
        if !FileManager.default.fileExists(atPath: userPath!) {
            guard ((try? FileManager.default.createDirectory(atPath: userPath!, withIntermediateDirectories: false, attributes: nil)) != nil) else {
                return
            }
        }
        let fileName = userPath?.stringByAppendingPathComponent(path: "person.db")
        dbQueue = FMDatabaseQueue(path: fileName)
    }
}

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsString = self as NSString
        return nsString.appendingPathComponent(path)
    }
}

