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
    @Environment(PortfolioManager.self) var portfolioManager
    @Query(sort: \Portfolio.name) var portfolios: [Portfolio]
    
    @State private var showingAddScreen = false
    @State private var isLoading = true
    
    var body: some View {
        let portfolio = portfolioManager.selectedPortfolio

        VStack {
            if isLoading {
                // Splash screen
                VStack {
                    Spacer()
                    Image(systemName: "shippingbox.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.accentColor)
                        .padding(.bottom)
                    Text("Crate Ledger")
                        .font(.title)
                        .bold()
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .transition(.opacity)
            } else if let portfolio {
                TabView {
                    SummaryView(portfolio: portfolio)
                        .tabItem {
                            Label("Summary", systemImage: "chart.pie")
                        }
                    AllAssetsView(portfolio: portfolio)
                        .tabItem {
                            Label("Assets", systemImage: "folder")
                        }
                    PerformanceView()
                        .tabItem {
                            Label("Performance", systemImage: "chart.line.uptrend.xyaxis")
                        }
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                ContentUnavailableView {
                    VStack(spacing: 8) {
                        Label("Welcome to Crate Ledger", systemImage: "shippingbox.fill")
                            .font(.title2.bold())
                        Text("Let’s get you started by creating your first portfolio.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                    }
                } description: {
                    Text("Crate Ledger helps you track your crypto, stocks, and other assets in one place. Portfolios are how you organize everything.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding()
                } actions: {
                    Button {
                        withAnimation {
                            let newPortfolio = Portfolio(name: "My Portfolio")
                            modelContext.insert(newPortfolio)
                            portfolioManager.select(newPortfolio)
                        }
                    } label: {
                        Label("Create Portfolio", systemImage: "plus")
                            .font(.headline)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .animation(.easeInOut, value: portfolioManager.selectedPortfolio)
        .task {
            if portfolioManager.selectedPortfolio == nil && !portfolios.isEmpty {
                portfolioManager.loadSelectedPortfolio(from: modelContext)
            }
            isLoading = false
        }
    }

    
    func deleteData() {
        try? modelContext.delete(model: Portfolio.self)
    }
}

#Preview {
    ContentView()
}
