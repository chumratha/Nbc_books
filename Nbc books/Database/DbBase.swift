//
//  DbBase.swift
//  GDI_IDC
//
//  Created by Chum Ratha on 4/2/17.
//  Copyright © 2017 Chum Ratha. All rights reserved.
//

import UIKit

struct Types {
    static let TEXT = "TEXT"
    static let INT = "INTEGER"
    static let DATETIME = "DATETIME"
    static let PRIMARY_KEY = "INTEGER PRIMARY KEY"
}



class DbBase: NSObject {
    
    static private let path = "news.db"
    static private var queue:FMDatabase?
    
    private var columns_name = ""
    
    override init() {
        super.init()
        if DbBase.queue == nil {
            let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let path = docPath.appending("/news.db")
            DbBase.queue = FMDatabase(path: path)
            if !(DbBase.queue?.open())! {
                print("open db failed")
            }
        }
        
        // create table
        
        if var dicTable = self.getTable() {
            if self.getKeyColumn() == "" {
                // set primary key text
                dicTable["id"] = "TEXT PRIMARY KEY"
            } else {
                // set auto increment
                dicTable[self.getKeyColumn()] = Types.PRIMARY_KEY
            }
            var stmt = "CREATE TABLE " + self.getTableName() + "("
            for (key,value) in dicTable {
                stmt = stmt + key + " " + value + ","
                self.columns_name = self.columns_name + key + ","
            }
            stmt = stmt.substring(to: stmt.index(stmt.startIndex, offsetBy: (stmt as NSString).length - 2))
            stmt = stmt + ")"
            DbBase.queue?.executeStatements(stmt)
            
            self.columns_name = self.columns_name.substring(to: self.columns_name.index(self.columns_name.startIndex, offsetBy: (self.columns_name as NSString).length - 2))
        }
    }
    
    
    // Override method
    public func getTable() -> [String:String]? {
        return nil
    }
    public func getTableName() -> String {
        return ""
    }
    
    public func insert(dict: [String:Any]) -> Bool {
        // clear cache
        var strFields = ""
        var strVals = ""
        for (field,_) in mapDataWithCol(dict:dict) {
            if strFields.count > 0 {
                strFields += ", "
            }
            strFields += field
            if strVals.count > 0 {
                strVals += ", "
            }
            strVals += ":" + field
        }
        let query = "INSERT INTO \(self.getTableName()) (\(strFields)) values (\(strVals))"
        let result = (DbBase.queue?.executeUpdate(query, withParameterDictionary: dict))!
        print(DbBase.queue?.lastErrorMessage())
        return result
    }
    
    internal func mapDataWithCol(dict:[String:Any]) -> [String:Any] {
        var tmpDict:[String:Any] = [:]
        if let dicTable = self.getTable() {
            for (key,_) in dicTable {
               tmpDict[key] = dict[key]
            }
            tmpDict[self.getKeyColumn()] = dict[self.getKeyColumn()]
        }
        return tmpDict
    }
    
    public func selectTop(_ top:Int) -> [Any]{
        var query = "SELECT * FROM \(self.getTableName())"
        if (orderBy() != nil) {
            query += " ORDER BY " + orderBy()!
        }
        query += " LIMIT \(top)"
        var arrValues:[Any] = []
        let rs = DbBase.queue?.executeQuery(query, withParameterDictionary: [:])
        if rs != nil {
            while (rs?.next())! {
                let obj = self.mapResultSet(rs: rs!)
                arrValues.append(obj)
            }
        }
        return arrValues
    }
    
    public func selectAll() -> [Any] {
        var query = "SELECT * FROM \(self.getTableName())"
        if (orderBy() != nil) {
            query += " ORDER BY " + orderBy()!
        }
        var arrValues:[Any] = []
        let rs = DbBase.queue?.executeQuery(query, withParameterDictionary: [:])
        if rs != nil {
            while (rs?.next())! {
                let obj = self.mapResultSet(rs: rs!)
                arrValues.append(obj)
            }
        }
        return arrValues
    }
    
    func upsert(dict:[String:Any]) {
        let key = self.getKeyColumn() == "" ? "id" : self.getKeyColumn()
        if dict[key] != nil {
            let existing = self.select(by: key, value: dict[key]! )
            if existing.count > 0 {
                self.update(dict: dict)
            }
            else {
                _ = self.insert(dict: dict)
            }
        }
        else {
            print("\(key) required")
        }
    }
    
    public func select(by field:String, value: Any) -> [Any]{
        let query = "SELECT * FROM \(self.getTableName()) WHERE " + field + " = :value"
        let valDic = ["value": value]
        var list:[Any] = []
        let rs = DbBase.queue?.executeQuery(query, withParameterDictionary: valDic)
        if rs != nil {
            while (rs?.next())! {
                list.append(self.mapResultSet(rs: rs!))
            }
        }
        return list
    }
    
    public func select(by filterDict:[String:Any]) -> [Any] {
        var query = "SELECT * FROM \(self.getTableName()) WHERE "
        let keys = Array(filterDict.keys)
        
        for i in 0...(keys.count - 1) {
            let key = keys[i]
            if i == keys.count - 1 {
                query += "\(key) = :\(key)"
            }else {
                query += "\(key) = :\(key) AND "
            }
        }
        
        var list:[Any] = []
        let rs = DbBase.queue?.executeQuery(query, withParameterDictionary: filterDict)
        if rs != nil {
            while (rs?.next())! {
                list.append(self.mapResultSet(rs: rs!))
            }
        }
        return list
    }
    
    internal func update(dict:[String:Any]) {
        let keyCol = self.getKeyColumn()
        var strFields = ""
        for (field,_) in mapDataWithCol(dict:dict) {
            if field != keyCol {
                if strFields.count > 0 {
                    strFields += ", ";
                }
                strFields += field + " = :" + field
            }
        }
        let query = "UPDATE \(self.getTableName()) SET \(strFields) WHERE \(keyCol) = :\(keyCol)"
        DbBase.queue?.executeUpdate(query, withParameterDictionary: dict)
        print(DbBase.queue?.lastErrorMessage())
    }
    
    internal func mapResultSet(rs:FMResultSet) -> [String:Any] {
        var dict:[String:Any] = [:]
        for i : Int32 in 0..<rs.columnCount() {
            let colName = rs.columnName(for: i)!
            dict[colName] = rs.object(forColumnIndex: i)
        }
        return dict
    }
    
    internal func getKeyColumn() -> String{
        return ""
    }
    
    internal func orderBy() -> String? {
        return nil;
    }
    
}
