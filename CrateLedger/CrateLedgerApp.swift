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
    var body: some Scene {
        WindowGroup {
            PortfolioView()
        }
        .modelContainer(for: Portfolio.self)
    }
}
