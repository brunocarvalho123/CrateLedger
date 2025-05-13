//
//  AssetView.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 26/04/2025.
//

import SwiftUI
import SwiftData

struct AssetView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @Bindable var portfolio: Portfolio
    @Bindable var asset: Asset
    
    @State private var viewModel = ViewModel()

    var body: some View {
        VStack {
            if asset.hasImage {
                AsyncImage(url: URL(string: asset.image)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else if phase.error != nil {
                        // Error
                    } else {
                        // Placeholder
                        ProgressView()
                    }
                }
                .frame(height: 100)
            }
            Form {
                Text("Asset type: \(asset.type.displayName)")
                Section("Asset info") {
                    TextField("Name", text: asset.nameBinding)
                    TextField("Symbol", text: asset.symbolBinding)
                    TextField("Price", value: asset.priceBinding, format: .currency(code: "USD"))
                }
                .disabled(asset.remoteManaged)
                Section("Amount") {
                    TextField("Amount held", value: asset.unitsBinding, format: .number)
                }
                Section("Notes") {
                    TextEditor(text: $asset.notes)
                }
                
                Section(asset.remoteManaged ? "Updated at: \(asset.lastUpdate)" : "") {
//                    Task {
//                        await viewModel.remoteFetch(asset: asset)
//                    }
                    Button("OK") {
                        viewModel.save(portfolio: portfolio, asset: asset)
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Edit asset")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete asset", isPresented: $viewModel.showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteAsset)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
        .alert(viewModel.errorTitle, isPresented: $viewModel.showingError) { } message: {
            Text(viewModel.errorMessage)
        }
        .toolbar {
            Button("Delete this asset", systemImage: "trash") {
                viewModel.showingDeleteAlert = true
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
    
    // Cant move this to ViewModel because of modelContext call
    func deleteAsset() {
        modelContext.delete(asset)
        dismiss()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Asset.self, configurations: config)
        let asset = Asset.example()
        let portfolio = Portfolio.example()
        return AssetView(portfolio: portfolio, asset: asset)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
