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
            VStack {
                if asset.hasImage {
                    AsyncImage(url: URL(string: asset.image)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                        } else if phase.error != nil {
                            // Error
                            Text(asset.symbol)
                                .bold()
                                .frame(width: 48, height: 48)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        } else {
                            // Placeholder
                            ProgressView()
                        }
                    }
                } else {
                    Text(asset.symbol)
                        .bold()
                        .frame(width: 48, height: 48)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
            }
            .padding(.trailing)
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
        let asset = Asset.example()
        return AssetRow(asset: asset)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
