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
            Form {
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(asset.remoteManaged ? "Not Custom Asset" : "Custom Asset")
                                .font(.subheadline)
                                .foregroundStyle(asset.remoteManaged ? Color.secondary : Color.green)
                        }
                        Spacer()
                        if asset.hasImage {
                            AsyncImage(url: URL(string: asset.image)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                } else if phase.error != nil {
                                    // Error
                                } else {
                                    // Placeholder
                                    ProgressView()
                                }
                            }
                            .frame(width: 40, height: 40)
                        }
                    }
                }

                Section(header: Text("Details")) {
                    Picker("Asset Type", selection: asset.typeBinding) {
                        ForEach(Asset.TypeEnum.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .disabled(asset.remoteManaged)

                    VStack(alignment: .leading) {
                        Text("Name")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("e.g. Bitcoin", text: asset.nameBinding)
                            .disabled(asset.remoteManaged)
                    }

                    VStack(alignment: .leading) {
                        Text("Symbol")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("e.g. BTC", text: asset.symbolBinding)
                            .disabled(asset.remoteManaged)
                    }

                    VStack(alignment: .leading) {
                        Text("Price (USD)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("e.g. 30000", value: asset.priceBinding, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .disabled(asset.remoteManaged)
                    }
                }

                Section(header: Text("Holdings")) {
                    TextField("Quantity", value: asset.unitsBinding, format: .number)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Notes")) {
                    TextEditor(text: $asset.notes)
                        .frame(minHeight: 120)
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
        .onAppear {
            if asset.remoteManaged && (asset.isStale || !portfolio.includes(asset: asset))  {
                Task {
                    await viewModel.remoteFetch(asset: asset)
                }
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
