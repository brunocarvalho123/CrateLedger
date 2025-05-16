//
//  CrateLedgerApp.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 24/04/2025.
//

import SwiftUI
import SwiftData

@main
struct CrateLedgerApp: App {
    @State private var portfolioManager = PortfolioManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(portfolioManager)
        }
        .modelContainer(for: Portfolio.self)
    }
}
