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
    var types: [Asset.TypeEnum]?
    
    @State private var showingAssetOptions = false
    @State private var showingAddScreen = false
    @State private var selectedType: Asset.TypeEnum?
    
    @State private var searchText = ""
    
    var assets: [Asset] {
        var tmpAssets: [Asset]
        if let types {
            tmpAssets = portfolio.assets(types: types)
        } else {
            tmpAssets = portfolio.assets
        }

        if !searchText.isEmpty {
            tmpAssets = tmpAssets.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.symbol.localizedCaseInsensitiveContains(searchText)
            }
        }
        return tmpAssets
    }
    
    var assetListTitle: String {
        types?.count == 1 ? types!.first!.displayName : "Assets"
    }
    
    var body: some View {
        let filteredAssets: [Asset] = assets

        VStack {
            List {
                if filteredAssets.isEmpty {
                    ContentUnavailableView {
                        Label("Asset not found", systemImage: "magnifyingglass")
                    } description: {
                        Text("You don't have any assets that match \"\(searchText)\"")
                    }
                    .padding()
                } else {
                    ForEach(filteredAssets) { asset in
                        NavigationLink(destination: AssetDetailView(portfolio: portfolio, asset: asset)) {
                            AssetRow(asset: asset)
                        }
                    }
                    .onDelete(perform: deleteAsset)
                }
            }
            .searchable(text: $searchText, prompt: "Search assets")
        }
        .navigationTitle(assetListTitle)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add asset", systemImage: "plus") {
                    if types?.count == 1 {
                        selectedType = types?.first
                        showingAddScreen = true
                        return
                    }
                    showingAssetOptions = true
                }
            }
        }
        .sheet(isPresented: $showingAddScreen) {
            AssetDetailView(portfolio: portfolio, asset: Asset.empty(type: selectedType ?? .crypto))
        }
        .confirmationDialog("Choose asset type", isPresented: $showingAssetOptions, titleVisibility: .visible) {
            ForEach(types ?? Asset.TypeEnum.allCases) { type in
                Button(type.displayName) {
                    selectedType = type
                    showingAddScreen = true
                }
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
