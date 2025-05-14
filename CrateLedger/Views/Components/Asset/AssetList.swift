//
//  AssetList.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 07/05/2025.
//

import SwiftUI
import SwiftData

struct AssetList: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var portfolio: Portfolio
    
    init(portfolio: Portfolio, types: [Asset.TypeEnum] = []) {
        self.portfolio = portfolio
        viewModel.types = types
    }

    @State private var viewModel = ViewModel()
    
    var body: some View {
        let filteredAssets: [Asset] = viewModel.filterAssets(portfolio: portfolio)

        VStack {
            List {
                if filteredAssets.isEmpty {
                    ContentUnavailableView {
                        Label("Asset not found", systemImage: "magnifyingglass")
                    } description: {
                        Text("You don't have any assets that match \"\(viewModel.searchText)\"")
                    }
                    .padding()
                } else {
                    ForEach(filteredAssets) { asset in
                        NavigationLink(destination: AssetView(portfolio: portfolio, asset: asset)) {
                            AssetRow(asset: asset)
                        }
                    }
                    .onDelete(perform: deleteAsset)
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search assets")
        }
        .navigationTitle(viewModel.assetListTitle)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add asset", systemImage: "plus", action: viewModel.showAddAsset)
            }
        }
        .sheet(isPresented: $viewModel.showingAddScreen) {
            SearchView(portfolio: portfolio, type: viewModel.selectedType)
        }
        .confirmationDialog("Choose asset type", isPresented: $viewModel.showingAssetOptions, titleVisibility: .visible) {
            ForEach(viewModel.types.count > 0 ? viewModel.types : Asset.TypeEnum.allCases) { type in
                Button(type.displayName) { viewModel.showAddAsset(type: type) }
            }
        }
    }

    func deleteAsset(at offsets: IndexSet) {
        for offset in offsets {
            let asset = portfolio.assets[offset]
            modelContext.delete(asset)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Portfolio.self, configurations: config)
        let portfolio = Portfolio.example()
        return AssetList(portfolio: portfolio)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
