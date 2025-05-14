//
//  AssetListModel.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 03/05/2025.
//

import Foundation

extension AssetList {
    @Observable
    class ViewModel {
        var types: [Asset.TypeEnum] = []
        var showingAddScreen = false
        var selectedType: Asset.TypeEnum? = nil
        
        var searchText = ""
        
        func filterAssets(portfolio: Portfolio) -> [Asset] {
            var tmpAssets: [Asset]
            if types.count > 0 {
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
        
        func showAddAsset() {
            if types.count == 1 {
                selectedType = types.first
            } else {
                selectedType = nil
            }
            showingAddScreen = true
        }
        
        func showAddAsset(type: Asset.TypeEnum) {
            selectedType = type
            showingAddScreen = true
        }
        
        var assetListTitle: String {
            types.count == 1 ? types.first!.displayName : "All Assets"
        }
        
    }
}
