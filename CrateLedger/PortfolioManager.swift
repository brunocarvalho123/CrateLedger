//
//  PortfolioManager.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 16/05/2025.
//

import Foundation
import SwiftData

@Observable
class PortfolioManager {
    private let portfolioKey = "selectedPortfolio"

    private var portfolioId: String? {
        get {
            UserDefaults.standard.string(forKey: portfolioKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: portfolioKey)
        }
    }

    var selectedPortfolio: Portfolio? = nil

    func loadSelectedPortfolio(from context: ModelContext) {
        guard let idString = portfolioId, let uuid = UUID(uuidString: idString) else {
            selectedPortfolio = nil
            return
        }

        do {
            let portfolios = try context.fetch(FetchDescriptor<Portfolio>())
            selectedPortfolio = portfolios.first(where: { $0.id == uuid })
        } catch {
            print("Failed to fetch portfolio: \(error)")
            selectedPortfolio = nil
        }
    }
    
    func clearSelectedPortfolio() {
        selectedPortfolio = nil
        portfolioId = nil
    }

    func select(portfolio: Portfolio) {
        selectedPortfolio = portfolio
        portfolioId = portfolio.id.uuidString
    }
}
