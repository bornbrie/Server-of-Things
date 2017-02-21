//
//  Thing.swift
//  Server of Things
//
//  Created by Benjamin Heutmaker on 1/26/17.
//
//

import Foundation
import PerfectLib
import StORM
import SQLiteStORM

class Thing: SQLiteStORM {
    
    var id = String()
    var name = String()
    var icon = String()
    var owner = String()
    var attributes = String()
    var created = String()
    var updated = String()
    
    override init() {
        super.init()
        
        let attributes: [[String:Any]] = Attribute().rowsOwned(by: id)
        print("Attributes:", attributes)
        
        do {
            let jsonAttributes = try attributes.jsonEncodedString()
            self.attributes = jsonAttributes
        } catch {
            print(error)
        }
    }
    
    override open func table() -> String {
        return "things"
    }
    
    override func to(_ this: StORMRow) {
        id          = this.data[Keys.id] as! String
        name        = this.data[Keys.name] as! String
        icon        = this.data[Keys.icon] as! String
        owner       = this.data[Keys.owner] as! String
        attributes  = this.data[Keys.attributes] as! String
        created     = this.data[Keys.created] as! String
        updated     = this.data[Keys.updated] as! String
    }
    
    func rows() -> [Thing] {
        var rows = [Thing]()
        for i in 0..<self.results.rows.count {
            let row = Thing()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
    func rowsOwned(by owner: String) -> [Thing] {
        do {
            try select(whereclause: "owner = :1", params: [owner], orderby: [])
        } catch {
            print(error)
        }
        return self.rows()
    }
    
    func rowsOwned(by owner: String) -> [[String : Any]] {
        let things: [Thing] = rowsOwned(by: owner)
        return things.map({ (thing) -> [String:Any] in
            return thing.asDataDict()
        })
    }
}
