//
//  NoSearchResults.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 12/05/2025.
//

import SwiftUI

struct NoSearchResults: View {
    let query: String
    let type: Asset.TypeEnum?

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
        .padding()
    }
    
    func isSimpleWord(_ text: String) -> Bool {
        let pattern = #"^\w+$"#
        return text.range(of: pattern, options: .regularExpression) != nil
    }
    
    func createCustomAsset() {
        let symbol = query.uppercased()
        let asset = Asset.empty(type: type ?? .other)
        asset.name = query
        asset.symbol = symbol
        // Navigate or present AssetView with this asset
        // Example:
        // navigation.push(AssetView(asset: asset, ...))
    }
}

#Preview {
    NoSearchResults(query: "Test query", type: .etf)
}
