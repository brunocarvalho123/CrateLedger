//
//  NoSearchResults.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 12/05/2025.
//

import SwiftUI

struct NoSearchResults: View {
    
    @Bindable var portfolio: Portfolio
    
    let query: String
    let type: Asset.TypeEnum?
    @State private var customAsset: Asset?

    var body: some View {
        ContentUnavailableView {
            Label("No Assets found", systemImage: "magnifyingglass")
        } description: {
            Text("The search term “\(query)” did not match any assets.")
        } actions: {
            if isSimpleWord(query) {
                Button("Create custom asset “\(query.uppercased())”") {
                    createCustomAsset()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .sheet(item: $customAsset) { asset in
            AssetView(portfolio: portfolio, asset: asset)
        }
        .padding()
    }
    
    func isSimpleWord(_ text: String) -> Bool {
        let pattern = #"^\w+$"#
        return text.range(of: pattern, options: .regularExpression) != nil
    }
    
    func createCustomAsset() {
        let symbol = query.uppercased()
        let asset = Asset(name: query, type: type ?? .other, price: 0.0, symbol: symbol, units: 0.0, updatedAt: .now, createdAt: .now, image: "", notes: "")
        customAsset = asset
    }
}

#Preview {
    NoSearchResults(portfolio: Portfolio.example(), query: "Test query", type: .etf)
}
