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
    @State private var showingError = false
    @State private var isLoading = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""

    var body: some View {
        Form {
            Section("Asset info") {
                TextField("Name", text: $asset.name)
                    .disabled(asset.remoteManaged)
                TextField("Symbol", text: $asset.symbol)
                    .disabled(asset.remoteManaged)
                TextField("Type", text: $asset.type)
                    .disabled(asset.remoteManaged)
                TextField("Price", value: $asset.price, format: .currency(code: "USD"))
                    .disabled(asset.remoteManaged)
            }
            Section("Amount") {
                TextField("Amount held", value: $asset.units, format: .number)
            }
            Section("Notes") {
                TextEditor(text: $asset.notes)
            }
            
            Section(asset.remoteManaged ? "Updated at: \(asset.lastUpdate)" : "") {
                Toggle("Remote managed", isOn: $asset.remoteManaged)
                    .onChange(of: asset.remoteManaged) {
                        if asset.remoteManaged {
                            Task {
                                await updateAssetFromRemote()
                            }
                        }
                    }
                Button("Fetch Asset") {
                    Task {
                        await updateAssetFromRemote()
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
        .alert(errorTitle, isPresented: $showingError) { } message: {
            Text(errorMessage)
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
    
    func updateAssetFromRemote() async {
        isLoading = true
        defer { isLoading = false }
        
        let assetDTO = await AssetFetcherService.shared.fetchAsset(symbol: asset.symbol)
        
        if assetDTO.symbol == "ERR" {
            errorTitle = "Error!"
            errorMessage = "Failed to update asset from remote. Please try again later."
            showingError = true
            asset.remoteManaged = false
            return
        }
        
        asset.updateFromRemote(remoteAsset: assetDTO)
    }
}

#Preview {
    //AssetDetailView()
}
