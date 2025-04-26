//
//  PortfolioView.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 26/04/2025.
//

import SwiftUI
import SwiftData

struct PortfolioView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var portfolio: Portfolio
    
    @State private var showingAddScreen = false

    var body: some View {
        List {
            ForEach(portfolio.assets) { asset in
                NavigationLink(value: asset) {
                    HStack {
                        Text(asset.symbol)
                            .font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text(asset.name)
                                .font(.headline)
                            Text(asset.type)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .onDelete(perform: deleteAsset)
        }
        .navigationTitle($portfolio.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add asset", systemImage: "plus") {
                    showingAddScreen.toggle()
                }
            }
        }
        .sheet(isPresented: $showingAddScreen) {
            let newAsset = Asset(name: "", type: "", price: 0, symbol: "", units: 0)
            AssetDetailView(asset: newAsset, action: "create")
        }
    }
    
    func deleteAsset(at offsets: IndexSet) {
        for offset in offsets {
            let asset = portfolio.assets[offset]
            modelContext.delete(asset)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Portfolio.self, configurations: config)
        let portfolio = Portfolio(name: "Test Portfolio", assets: [Asset(name: "Test Asset", type: "crypto", price: 32.23, symbol: "TEST", units: 1.3)])
        return PortfolioView(portfolio: portfolio)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
