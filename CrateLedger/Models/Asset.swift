//
//  Asset.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 26/04/2025.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Asset {
    private(set) var name: String = "undefined" // Mandatory
    private(set) var type: TypeEnum = TypeEnum.other // Mandatory
    private(set) var price: Double = 0.0 // Mandatory
    private(set) var symbol: String = "undefined" // Mandatory
    private(set) var units: Double = 0.0
    private(set) var updatedAt: Date = Date.now
    private(set) var createdAt: Date = Date.now
    var image: String = ""
    var notes: String = ""
    private(set) var remoteManaged = false
    
    // These fields can only be edited if asset isn't remotely managed
    var nameBinding: Binding<String> {
        Binding(
            get: { self.name },
            set: { (self.remoteManaged == false ? (self.name = $0) : (self.name = self.name)) }
        )
    }
    var typeBinding: Binding<TypeEnum> {
        Binding(
            get: { self.type },
            set: { (self.remoteManaged == false ? (self.type = $0) : (self.type = self.type)) }
        )
    }
    var priceBinding: Binding<Double> {
        Binding(
            get: { self.price },
            set: { (self.remoteManaged == false ? (self.price = max(0, $0)) : (self.price = self.price)) }
        )
    }
    var symbolBinding: Binding<String> {
        Binding(
            get: { self.symbol },
            set: { (self.remoteManaged == false ? (self.symbol = $0.uppercased()) : (self.symbol = self.symbol)) }
        )
    }
    var unitsBinding: Binding<Double> {
        Binding(
            get: { self.units },
            set: {
                switch self.type {
                case .crypto, .metal, .cash, .other:
                    self.units = max(0, $0)
                    break
                case .stock, .etf, .bond:
                    self.units = round(max(0, $0))
                    break
                }
            }
        )
    }
    
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
    
    var imageURL: URL? {
        if self.image.starts(with: "http") {
            return URL(string: self.image)
        } else {
            return URL(fileURLWithPath: self.image)
        }
    }

    var isRemoteImage: Bool {
        return self.image.starts(with: "http")
    }
    
    var hasRequiredFields: Bool {
        return self.name != "" && self.symbol != ""
    }
    
    var key: String {
        return "\(self.type.id)_\(self.symbol.uppercased())"
    }
    
    var isStale: Bool {
        let staleInterval: TimeInterval

        switch self.type {
        case .crypto:
            staleInterval = -300 // 5 minutes
        case .etf, .stock:
            staleInterval = -1800 // 30 minutes
        case .cash, .metal:
            staleInterval = -86400 // 24 hours
        case .other, .bond:
            return false
        }

        let thresholdDate = Date().addingTimeInterval(staleInterval)
        return self.remoteManaged && self.updatedAt <= thresholdDate
    }
    
    init(name: String, type: TypeEnum, price: Double, symbol: String, units: Double = 0.0, updatedAt: Date = .now, createdAt: Date = .now, image: String = "", notes: String = "") {
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
        self.type = TypeEnum.from(raw: remoteAsset.type)
        self.price = remoteAsset.price
        self.symbol = remoteAsset.symbol
        self.image = remoteAsset.image ?? ""
    }
    
    init(searchResult: SearchResult) {
        self.name = searchResult.name
        self.type = TypeEnum.from(raw: searchResult.type)
        self.symbol = searchResult.symbol
        self.remoteManaged = true
    }
    
    func updateFromRemote(remoteAsset: AssetDTO) {
        self.price = remoteAsset.price
        self.updatedAt = Date.now
        self.image = remoteAsset.image ?? ""
    }
    
    func addUnits(_ units: Double) {
        switch self.type {
        case .crypto, .metal, .cash, .other:
            self.units += max(0, units)
            break
        case .stock, .etf, .bond:
            self.units += round(max(0, units))
            break
        }
    }
    
    static func empty(type: TypeEnum = TypeEnum.other) -> Asset {
        Asset(name: "", type: type, price: 0, symbol: "", units: 0)
    }
    
    enum TypeEnum: String, CaseIterable, Identifiable, Codable {
        case crypto
        case stock
        case etf
        case bond
        case metal
        case cash
        case other

        var id: String { rawValue }

        var displayName: String {
            switch self {
            case .crypto: return "Crypto"
            case .stock: return "Stock"
            case .etf: return "ETF"
            case .bond: return "Bond"
            case .metal: return "Metal"
            case .cash: return "Cash"
            case .other: return "Other"
            }
        }

        var systemImage: String {
            switch self {
            case .crypto: return "bitcoinsign.circle"
            case .stock: return "chart.line.uptrend.xyaxis"
            case .etf: return "chart.pie"
            case .bond: return "banknote"
            case .metal: return "cube.transparent"
            case .cash: return "dollarsign.circle"
            case .other: return "questionmark.circle"
            }
        }
        
        var color: Color {
            switch self {
            case .crypto: return Color(hex: "#468FF2")     // Soft blue (used in logo)
            case .stock:  return Color(hex: "#94A3B8")     // Slate gray (neutral, professional)
            case .etf:    return Color(hex: "#5E60CE")     // Muted indigo (financial, stable)
            case .bond:   return Color(hex: "#3A506B")     // Steely blue (serious tone)
            case .metal:  return Color(hex: "#F4C430")     // Gold-ish yellow (precious metals)
            case .cash:   return Color(hex: "#38B2AC")     // Teal (represents liquidity)
            case .other:  return Color(hex: "#CBD5E1")     // Light gray (default, de-emphasized)
            }
        }
        
        static func from(raw: String) -> TypeEnum {
            let cleaned = raw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            return TypeEnum(rawValue: cleaned) ?? .other
        }
    }
    
    #if DEBUG
    static func example() -> Asset {
        Asset(name: "Test Asset", type: .crypto, price: 32.23, symbol: "TEST", units: 1.3, image: "https://assets.coingecko.com/coins/images/26375/standard/sui-ocean-square.png?1727791290")
    }
    #endif
}
