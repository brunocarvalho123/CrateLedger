//
//  SearchView.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 11/05/2025.
//

import SwiftUI
import Combine

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    
    let type: Asset.TypeEnum? = nil
    
    @State private var query = ""
    @State private var results: [SearchResult] = []
    @State private var isLoading = false
    @State private var showCustomAsset = false
    @State private var debouncing = false
    @FocusState private var isSearchFieldFocused: Bool

    private let debounceDelay: TimeInterval = 0.4
    @State private var debounceTimer: AnyCancellable?

    var body: some View {
        VStack {
            TextField("Search assets", text: $query)
                .textFieldStyle(.roundedBorder)
                .padding()
                .focused($isSearchFieldFocused)
                .onChange(of: query) {
                    handleQueryChange(query)
                }

            if isLoading {
                ProgressView()
                    .padding()
            } else if results.isEmpty && query.count >= 3 && debouncing == false {
                NoSearchResults(query: query, type: type)
            } else if results.isEmpty && query.count < 3 && debouncing == false {
                NoSearchQuery()
            } else {
                List(results) { asset in
                    Button {
                        add(asset)
                    } label: {
                        SearchResultRow(asset: asset)
                    }
                    .buttonStyle(.plain)
                }
            }
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isSearchFieldFocused = true
            }
        }
    }

    func handleQueryChange(_ newValue: String) {
        debounceTimer?.cancel()
        debouncing = true

        guard newValue.count >= 3 else {
            results = []
            debouncing = false
            return
        }

        debounceTimer = Just(newValue)
            .delay(for: .seconds(debounceDelay), scheduler: RunLoop.main)
            .sink { q in
                Task {
                    await search(query: q)
                    debouncing = false
                }
            }
    }
    
    func search(query: String) async {
        guard query.count >= 3 else { return }
        isLoading = true
        results = []
        results = await AssetFetcherService.shared.searchAssets(query: query, type: type)
        isLoading = false
    }

    func add(_ remote: SearchResult) {
        // Handle adding the remote asset to portfolio
        // Or navigate to a detail view for confirmation/edit
    }
}


#Preview {
    SearchView()
}
