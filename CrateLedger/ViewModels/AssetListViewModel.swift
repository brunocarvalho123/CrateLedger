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
        
        enum SortOption: String, CaseIterable {
            case name = "Name"
            case value = "Value"
            case type = "Type"
            case created_at = "Created date"
        }
        var sortOption: SortOption = .value
        
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
            return sortAssets(tmpAssets)
        }
        
        private func sortAssets(_ assets: [Asset]) -> [Asset] {
           switch sortOption {
           case .name:
               return assets.sorted { $0.name < $1.name }
           case .value:
               return assets.sorted { $0.value > $1.value }
           case .type:
               return assets.sorted { $0.type.rawValue < $1.type.rawValue }
           case .created_at:
               return assets.sorted { $0.createdAt < $1.createdAt }
           }
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
