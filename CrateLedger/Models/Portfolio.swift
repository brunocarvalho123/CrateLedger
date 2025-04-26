//
//  Portfolio.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 26/04/2025.
//

import Foundation
import SwiftData

@Model
class Portfolio {
    var name: String = "undefined"
    
    @Relationship(deleteRule: .cascade) var assets: [Asset] = [Asset]()
    
    var value: Double {
        assets.reduce(0) { $0 + $1.value }
    }
    
    init(name: String, assets: [Asset] = []) {
        self.name = name
        self.assets = assets
    }
}
