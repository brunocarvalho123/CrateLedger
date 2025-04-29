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

    @Bindable var portfolio: Portfolio
    @Bindable var asset: Asset
    var isNew: Bool = true
    
    @State private var showingDeleteAlert = false
    @State private var isLoading = false

    var body: some View {
        Form {
            Section("Asset info") {
                TextField("Name", text: $asset.name)
                TextField("Symbol", text: $asset.symbol)
                TextField("Type", text: $asset.type)
                TextField("Price", value: $asset.price, format: .currency(code: "USD"))
            }
            Section("Amount") {
                TextField("Amount held", value: $asset.units, format: .number)
            }
            Section("Notes") {
                TextEditor(text: $asset.notes)
            }
            
            Section {
                Button("Fetch Assets") {
                    Task {
                        await fetchAssets()
                    }
                }
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
        .alert("Delete asset", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteAsset)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button("Delete this book", systemImage: "trash") {
                showingDeleteAlert = true
            }
        }
        .overlay {
            if isLoading {
                ProgressView()
            }
        }
    }
    
    func deleteAsset() {
        modelContext.delete(asset)
        dismiss()
    }
    
    func fetchAssets() async {
        isLoading = true
        defer { isLoading = false }
        
        let assetsDTO = await AssetFetcherService.shared.fetchAssets(symbols: ["BTC","SUI"])
        print("Done")
    }
}

#Preview {
    //AssetDetailView()
}
