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
    
    var hasAssets: Bool {
        !assets.isEmpty
    }
    
    init(name: String, assets: [Asset] = []) {
        self.name = name
        self.assets = assets
    }
    
    func insert(asset: Asset) {
        if asset.hasRequiredFields && !includes(asset: asset) {
            assets.append(asset)
        }
    }
    
    func includes(asset: Asset) -> Bool {
        assets.contains(where: { $0.key == asset.key })
    }
    
    #if DEBUG
    static func example() -> Portfolio {
        Portfolio(name: "Test Portfolio", assets: [Asset.example()])
    }
    #endif
}
