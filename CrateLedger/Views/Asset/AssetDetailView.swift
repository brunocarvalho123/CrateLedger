//
//  AssetDetailView.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 26/04/2025.
//

import SwiftUI

struct AssetDetailView: View {
    @Environment(\.dismiss) var dismiss

    @Bindable var portfolio: Portfolio
    @Bindable var asset: Asset
    var isNew: Bool = true

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
                if (isNew) {
                    Button("Save") {
                        if asset.symbol.isEmpty == false && asset.name.isEmpty == false && asset.type.isEmpty == false {
                            portfolio.assets.append(asset)
                        }
                        dismiss()
                    }
                } else {
                    Button("Done") {
                        dismiss()
                    }
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
