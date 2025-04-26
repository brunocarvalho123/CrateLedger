//
//  PortfolioView.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 26/04/2025.
//

import SwiftUI
import SwiftData

struct PortfolioView: View {
    @Bindable var portfolio: Portfolio
    
    var body: some View {
        Text("Portfolio View")
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Portfolio.self, configurations: config)
        let portfolio = Portfolio(name: "Test Portfolio")
        return PortfolioView(portfolio: portfolio)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
