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
    var name: String = "undefined"
    var type: String = "undefined"
    var price: Double = 0.0
    var symbol: String = "undefined"
    var units: Double = 0.0
    var updatedAt: Date = Date.now
    var createdAt: Date = Date.now
    
    @Relationship(deleteRule: .cascade) var image: Image? = Image(thumb: "", small: "", large: "")
    
    var value: Double {
        return price * units
    }
    
    init(name: String, type: String, price: Double, symbol: String, units: Double = 0.0, updatedAt: Date, createdAt: Date, image: Image? = nil) {
        self.name = name
        self.type = type
        self.price = price
        self.symbol = symbol
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.image = image
    }
}
