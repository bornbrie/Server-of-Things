//
//  Attribute.swift
//  Server of Things
//
//  Created by Benjamin Heutmaker on 1/27/17.
//
//

import Foundation
import PerfectLib
import StORM
import SQLiteStORM

class Attribute: SQLiteStORM {
    
    var id = String()
    var parent = String()
    var text = String()
    var type = String()
    
    override open func table() -> String {
        return "attributes"
    }
    
    override func to(_ this: StORMRow) {
        id      = this.data[Keys.id] as! String
        parent  = this.data[Keys.parent] as! String
        text    = this.data[Keys.text] as! String
        type    = this.data["type"] as! String
    }
    
    func rows() -> [Attribute] {
        var rows = [Attribute]()
        for i in 0..<self.results.rows.count {
            let row = Attribute()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
    func rowsOwned(by parent: String) -> [Attribute] {
        do {
            try select(whereclause: "parent = :1", params: [parent], orderby: [])
        } catch {
            print(error)
        }
        return self.rows()
    }
    
    func rowsOwned(by parent: String) -> [[String : Any]] {
        let attributes: [Attribute] = rowsOwned(by: parent)
        return attributes.map { attribute -> [String:Any] in
            return attribute.asDataDict()
        }
    }
}
