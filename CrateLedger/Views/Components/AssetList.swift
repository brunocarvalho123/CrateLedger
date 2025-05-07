//
//  AssetList.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 07/05/2025.
//

import SwiftUI
import SwiftData

struct AssetList: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var portfolio: Portfolio
    var types: [Asset.TypeEnum]?
    
    var body: some View {
        List {
            ForEach(assets()) { asset in
                NavigationLink(value: asset) {
                    AssetRow(asset: asset)
                }
            }
            .onDelete(perform: deleteAsset)
        }
    }
    
    func assets() -> [Asset] {
        if let types {
            return portfolio.assets(types: types)
        }
        return portfolio.assets
    }
    
    // Cant move this to ViewModel because of modelContext call
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
        let portfolio = Portfolio.example()
        return PortfolioView(portfolio: portfolio)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
