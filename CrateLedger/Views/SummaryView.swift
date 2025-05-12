//
//  SummaryView.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 26/04/2025.
//

import SwiftUI
import SwiftData

struct SummaryView: View {
    @Bindable var portfolio: Portfolio
    
    @State private var viewModel = ViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if portfolio.hasAssets {
                    SummaryChart(portfolio: portfolio)
                    SummaryTypeList(portfolio: portfolio)
                } else {
                    ContentUnavailableView {
                        Label("No Assets", systemImage: "magnifyingglass")
                    } description: {
                        Text("You don't have any saved assets in this portfolio.")
                    } actions: {
                        Button("Create an asset") {
                            viewModel.showingAssetOptions = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
            }
            .navigationTitle($portfolio.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Asset.TypeEnum.self) { type in
                AssetList(portfolio: portfolio, types: [type])
            }
            .onAppear {
                Task {
                    await viewModel.refreshAssetPrices(portfolio: portfolio)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add asset", systemImage: "plus") {
                        viewModel.showingAssetOptions = true
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddScreen) {
                AssetView(portfolio: portfolio, asset: Asset.empty(type: viewModel.selectedType))
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .confirmationDialog("Choose asset type", isPresented: $viewModel.showingAssetOptions, titleVisibility: .visible) {
                ForEach(Asset.TypeEnum.allCases) { type in
                    Button(type.displayName) {
                        viewModel.selectedType = type
                        viewModel.showingAddScreen = true
                    }
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Portfolio.self, configurations: config)
        let portfolio = Portfolio.example()
        return SummaryView(portfolio: portfolio)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
