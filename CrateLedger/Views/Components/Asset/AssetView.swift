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
    var fromSearch: Bool

    @State private var viewModel = ViewModel()
    
    init(portfolio: Portfolio, asset: Asset, fromSearch: Bool = false) {
        self.portfolio = portfolio
        self.asset = asset
        self.fromSearch = fromSearch
    }

    var body: some View {
        VStack {
            Form {
                Section {
                    HStack {
                        AssetImage(asset: asset)

                        Spacer()

                        Label {
                            Text(asset.remoteManaged ? "Up to date" : "Custom")
                        } icon: {
                            Image(systemName: asset.remoteManaged ? "arrow.triangle.2.circlepath" : "pencil")
                        }
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(asset.remoteManaged ? Color.green.opacity(0.15) : Color.gray.opacity(0.2))
                        .foregroundStyle(asset.remoteManaged ? Color.green : Color.secondary)
                        .clipShape(Capsule())
                    }
                }

                Section(header: Text("Details")) {
                    Picker(selection: asset.typeBinding, label: Text("Category")) {
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
                }
                
                Section {
                    Button() {
                        viewModel.save(portfolio: portfolio, asset: asset)
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Save")
                                .fontWeight(.semibold)
                            Spacer()
                        }
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
        .onAppear {
            if asset.remoteManaged && (asset.isStale || fromSearch)  {
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
