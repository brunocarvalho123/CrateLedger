//
//  AssetDetailViewModel.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 03/05/2025.
//

import Foundation

extension AssetDetailView {
    @Observable
    class ViewModel {
        var showingDeleteAlert = false
        var showingError = false
        var isLoading = false
        var errorTitle = ""
        var errorMessage = ""

        func isNewAsset(portfolio: Portfolio, asset: Asset) -> Bool {
            portfolio.includes(asset: asset) == false
        }
        
        func save(portfolio: Portfolio, asset: Asset) {
            portfolio.insert(asset: asset)
        }
        
        func remoteFetch(asset: Asset) async {
            isLoading = true
            defer { isLoading = false }
            
            let assetDTO = await AssetFetcherService.shared.fetchAsset(symbol: asset.symbol)
            
            if assetDTO.symbol == "ERR" {
                errorTitle = "Error!"
                errorMessage = "Failed to update asset from remote. Please try again later."
                showingError = true
                asset.remoteManaged = false
                return
            }
            
            asset.updateFromRemote(remoteAsset: assetDTO)
        }
    }
}
