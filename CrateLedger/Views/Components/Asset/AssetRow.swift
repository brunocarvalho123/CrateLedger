//
//  AssetRow.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 26/04/2025.
//

import SwiftUI
import SwiftData

struct AssetRow: View {
    var asset: Asset

    var body: some View {
        HStack {
            AssetImage(asset: asset, disablePicker: true)
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
