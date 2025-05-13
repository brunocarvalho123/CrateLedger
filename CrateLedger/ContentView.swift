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
        VStack {
            if portfolios.isEmpty {
                Button("Add Portfolio") {
                    let newPortfolio = Portfolio(name: "First Portfolio")
                    modelContext.insert(newPortfolio)
                }
            } else {
                TabView {
                    SummaryView(portfolio: portfolios[0])
                        .tabItem {
                            Label("Summary", systemImage: "chart.pie")
                        }
                    AssetListView(portfolio: portfolios[0])
                        .tabItem {
                            Label("Assets", systemImage: "folder")
                        }
                    SearchView(portfolio: portfolios[0])
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
                }
                
            }
        }
    }

    
    func deleteData() {
        try? modelContext.delete(model: Portfolio.self)
    }
}

#Preview {
    ContentView()
}
