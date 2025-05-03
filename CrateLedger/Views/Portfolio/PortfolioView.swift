//
//  PortfolioView.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 26/04/2025.
//

import SwiftUI
import SwiftData

struct PortfolioView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var portfolio: Portfolio
    
    @State private var showingAddScreen = false
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            VStack {
                if portfolio.hasAssets {
                    Text("Value: \(portfolio.value, format: .currency(code: "USD"))")
                    List {
                        ForEach(portfolio.assets) { asset in
                            NavigationLink(value: asset) {
                                AssetRow(asset: asset)
                            }
                        }
                        .onDelete(perform: deleteAsset)
                    }
                } else {
                    ContentUnavailableView {
                        Label("No Assets", systemImage: "magnifyingglass")
                    } description: {
                        Text("You don't have any saved assets in this portfolio.")
                    } actions: {
                        Button("Create an asset") {
                            showingAddScreen = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
            }
            .navigationTitle($portfolio.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Asset.self) { asset in
                AssetDetailView(portfolio: portfolio, asset: asset, isNew: false)
            }
            .onAppear {
                Task {
                    await updateRemoteAssets()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add asset", systemImage: "plus") {
                        showingAddScreen = true
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AssetDetailView(portfolio: portfolio, asset: Asset(name: "", type: "", price: 0, symbol: "", units: 0), isNew: true)
            }
            .overlay {
                if isLoading {
                    ProgressView()
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
    
    func updateRemoteAssets() async {
        let remoteAssets = portfolio.staleAssets
        if remoteAssets.count == 0 {
            return
        }

        isLoading = true
        defer { isLoading = false }
        
        let assetsDTO = await AssetFetcherService.shared.fetchAssets(symbols: remoteAssets.map(\.symbol))
        for assetDTO in assetsDTO {
            if assetDTO.symbol != "ERR" {
                remoteAssets.filter({ $0.symbol == assetDTO.symbol }).first?.updateFromRemote(remoteAsset: assetDTO)
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Portfolio.self, configurations: config)
        let portfolio = Portfolio.example()
        return PortfolioView(portfolio: portfolio)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
