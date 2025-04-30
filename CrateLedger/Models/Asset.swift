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
}
