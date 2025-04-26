//
//  AssetDetailView.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 26/04/2025.
//

import SwiftUI

struct AssetDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @Bindable var asset: Asset
    var action: String = "edit"

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $asset.name)
                TextField("Symbol", text: $asset.symbol)
            }
            
            Section("teste") {
                TextField("Type", text: $asset.type)
                TextField("Quantity", value: $asset.units, format: .number)
                TextField("Price", value: $asset.price, format: .currency(code: "USD"))
            }
            
            Section {
                Button("Save") {
                    modelContext.insert(asset)
                    dismiss()
                }
            }
        }
        .navigationTitle("Edit asset")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    //AssetDetailView()
}
