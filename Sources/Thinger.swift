//
//  Thinger.swift
//  Server of Things
//
//  Created by Benjamin Heutmaker on 1/26/17.
//
//

import Foundation
import PerfectLib

import StORM
import SQLiteStORM

import PerfectTurnstileSQLite

class Thinger: AuthAccount {
    
    var things = [String]()
    
    override func to(_ this: StORMRow) {
        super.to(this)
        
        let thingsString = this.data[Keys.things] as! String
        do {
            things = try thingsString.jsonDecode() as! [String]
        } catch {
            print("Error decoding things JSON in Thinger: \(error.localizedDescription)")
        }
    }
    
    func rows() -> [Thinger] {
        var rows = [Thinger]()
        for i in 0..<self.results.rows.count {
            let row = Thinger()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}
