//
//  AssetRow.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 26/04/2025.
//

import SwiftUI
import SwiftData

struct AssetRow: View {
    @Bindable var asset: Asset

    var body: some View {
        HStack {
            if asset.hasImage {
                AsyncImage(url: URL(string: asset.image)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else if phase.error != nil {
                        // Error
                        Text(asset.symbol)
                            .font(.largeTitle)
                    } else {
                        // Placeholder
                        ProgressView()
                    }
                }
                .frame(width: 65, height: 48)
            } else {
                Text(asset.symbol)
                    .font(.largeTitle)
                    .frame(width: 65, height: 48)
            }
            VStack(alignment: .leading) {
                Text(asset.name)
                    .font(.headline)
                Text(asset.value, format: .currency(code: "USD"))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Portfolio.self, configurations: config)
        let asset = Asset(name: "Test Asset", type: "crypto", price: 32.23, symbol: "TEST", units: 1.3, image: "https://assets.coingecko.com/coins/images/26375/standard/sui-ocean-square.png?1727791290")
        return AssetRow(asset: asset)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
