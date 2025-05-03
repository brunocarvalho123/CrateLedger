//
//  Asset.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 26/04/2025.
//

import Foundation
import SwiftData

@Model
class Asset {
    var name: String = "undefined" // Mandatory
    var type: String = "undefined" // Mandatory
    var price: Double = 0.0 // Mandatory
    var symbol: String = "undefined" // Mandatory
    var units: Double = 0.0
    var updatedAt: Date = Date.now
    var createdAt: Date = Date.now
    var image: String = ""
    var notes: String = ""
    var remoteManaged = false
    
    var value: Double {
        return price * units
    }
    
    var lastUpdate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: self.updatedAt)
    }
    
    var hasImage: Bool {
        return self.image != ""
    }
    
    var hasRequiredFields: Bool {
        return self.name != "" && self.type != "" && self.symbol != ""
    }
    
    var key: String {
        return "\(self.type)_\(self.symbol.uppercased())"
    }
    
    init(name: String, type: String, price: Double, symbol: String, units: Double = 0.0, updatedAt: Date = .now, createdAt: Date = .now, image: String = "", notes: String = "") {
        self.name = name
        self.type = type
        self.price = price
        self.symbol = symbol
        self.units = units
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.image = image
        self.notes = notes
    }
    
    init(remoteAsset: AssetDTO) {
        self.name = remoteAsset.name
        self.type = remoteAsset.type
        self.price = remoteAsset.price
        self.symbol = remoteAsset.symbol
        self.image = remoteAsset.image ?? ""
    }
    
    func updateFromRemote(remoteAsset: AssetDTO) {
        self.name = remoteAsset.name
        self.type = remoteAsset.type
        self.price = remoteAsset.price
        self.updatedAt = Date.now
        self.image = remoteAsset.image ?? ""
    }
    
    static func empty() -> Asset {
        Asset(name: "", type: "", price: 0, symbol: "", units: 0)
    }
    
    #if DEBUG
    static func example() -> Asset {
        Asset(name: "Test Asset", type: "crypto", price: 32.23, symbol: "TEST", units: 1.3, image: "https://assets.coingecko.com/coins/images/26375/standard/sui-ocean-square.png?1727791290")
    }
    #endif
}
