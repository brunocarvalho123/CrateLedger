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
    @Attribute(.unique) var id: UUID = UUID()
    var name: String = "undefined"
    
    @Relationship(deleteRule: .cascade) private(set) var assets: [Asset] = [Asset]()
    
    var value: Double {
        assets.reduce(0) { $0 + $1.value }
    }
    
    var staleAssets: [Asset] {
        return self.assets.filter({ $0.isStale })
    }
    
    var hasAssets: Bool {
        !assets.isEmpty
    }
    
    init(name: String, assets: [Asset] = []) {
        self.name = name
        self.assets = assets
    }
    
    func insert(asset: Asset) {
        if asset.hasRequiredFields {
            if (!includes(asset: asset)) {
                assets.append(asset)
            } else {
                if let assetOcurrence = assets.first(where: { ($0.key == asset.key) && ($0.remoteManaged == asset.remoteManaged) }) {
                    if (asset != assetOcurrence) {
                        assetOcurrence.addUnits(asset.units)
                    }
                }
                
            }
        }
    }
    
    func includes(asset: Asset) -> Bool {
        assets.contains(where: { ($0.key == asset.key) && ($0.remoteManaged == asset.remoteManaged) })
    }
    
    func valueIn(type: Asset.TypeEnum) -> Double {
        self.assets.filter({ $0.type == type }).reduce(0) { $0 + $1.value }
    }
    
    func valueIn(types: [Asset.TypeEnum]) -> Double {
        self.assets.filter({ types.contains($0.type) }).reduce(0) { $0 + $1.value }
    }
    
    func assets(type: Asset.TypeEnum) -> [Asset] {
        self.assets.filter({ $0.type == type })
    }
    
    func assets(types: [Asset.TypeEnum]) -> [Asset] {
        self.assets.filter({ types.contains($0.type) })
    }
    
    #if DEBUG
    static func example() -> Portfolio {
        Portfolio(name: "Test Portfolio", assets: [Asset.example()])
    }
    #endif
}
