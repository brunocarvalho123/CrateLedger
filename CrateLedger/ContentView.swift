//
//  ContentView.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 26/04/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Portfolio.name) var portfolios: [Portfolio]
    
    var body: some View {
        NavigationStack {
            if portfolios.isEmpty {
                Button("Add Portfolio") {
                    let newPortfolio = Portfolio(name: "First Portfolio")
                    modelContext.insert(newPortfolio)
                }
            } else {
                PortfolioView(portfolio: portfolios[0])
            }
        }
    }
}

#Preview {
    ContentView()
}
