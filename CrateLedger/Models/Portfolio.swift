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
    
    @Relationship(deleteRule: .cascade) var assets: [Asset]? = [Asset]()
    
    init(name: String, assets: [Asset]? = nil) {
        self.name = name
        self.assets = assets
    }
}
