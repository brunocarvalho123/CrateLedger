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
    
    var staleAssets: [Asset] {
        let staleInterval = Date().addingTimeInterval(-300) // 5 minutes
        return self.assets.filter({ $0.remoteManaged && $0.updatedAt <= staleInterval })
    }
    
    init(name: String, assets: [Asset] = []) {
        self.name = name
        self.assets = assets
    }
}
