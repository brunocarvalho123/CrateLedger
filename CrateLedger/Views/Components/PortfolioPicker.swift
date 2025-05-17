//
//  PortfolioPicker.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 17/05/2025.
//

import SwiftUI
import SwiftData

struct PortfolioPicker: View {
    @Environment(\.modelContext) var modelContext
    @Environment(PortfolioManager.self) private var portfolioManager
    @Query(sort: \Portfolio.name) private var portfolios: [Portfolio]

    @State private var showingCreateAlert = false
    @State private var showingRenameAlert = false
    @State private var showingDeleteAlert = false
    @State private var portfolioName = ""
    
    var body: some View {
        let selectedPortfolio = portfolioManager.selectedPortfolio

        Menu {
            Section {
                ForEach(portfolios) { portfolio in
                    Button {
                        portfolioManager.select(portfolio: portfolio)
                    } label: {
                        if selectedPortfolio?.persistentModelID == portfolio.persistentModelID {
                            Label(portfolio.name, systemImage: "checkmark")
                        } else {
                            Text(portfolio.name)
                        }
                    }
                }
            }
            Section {
                Button("Create", systemImage: "plus") {
                    showingCreateAlert = true
                }
                Button("Rename", systemImage: "pencil") {
                    showingRenameAlert = true
                }
                Button("Delete", systemImage: "trash", role: .destructive) {
                    showingDeleteAlert = true
                }
            }
        } label: {
            HStack(spacing: 5) {
                Text(selectedPortfolio?.name ?? "Select Portfolio")
                Image(systemName: "chevron.down")
                    .imageScale(.small)
                    .font(.headline)
            }
            .font(.headline)
            .foregroundStyle(.primary)
        }
        .alert("Create new portfolio", isPresented: $showingCreateAlert) {
            TextField("Portfolio name", text: $portfolioName)
            Button("Create", action: createPortfolio)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Enter portfolio name:")
        }
        .alert("Rename portfolio \(selectedPortfolio?.name ?? "")?", isPresented: $showingRenameAlert) {
            TextField("New name", text: $portfolioName)
            Button("Rename") { rename(portfolio: selectedPortfolio) }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Enter portfolio name:")
        }
        .alert("Delete portfolio \(selectedPortfolio?.name ?? "")?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) { delete(portfolio: selectedPortfolio) }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This cannot be undone.")
        }
    }
    
    func createPortfolio() {
        if portfolioName.count > 0 {
            let newPortfolio = Portfolio(name: portfolioName)
            modelContext.insert(newPortfolio)
            portfolioManager.select(portfolio: newPortfolio)
            portfolioName = ""
        }
    }
    
    func rename(portfolio: Portfolio?) {
        if portfolioName.count > 0 {
            guard portfolio != nil else { return }
            portfolio?.name = portfolioName
            portfolioName = ""
        }
    }
    
    func delete(portfolio: Portfolio?) {
        guard portfolio != nil else { return }
        modelContext.delete(portfolio!)
        
        if portfolios.count > 0 {
            portfolioManager.select(portfolio: portfolios[0])
        } else {
            portfolioManager.clearSelectedPortfolio()
        }
        
    }
}

#Preview {
    PortfolioPicker()
}
