//
//  SummaryViewModel.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 03/05/2025.
//

import Foundation

extension SummaryView {
    @Observable
    class ViewModel {
        var showingAddScreen = false
        var isLoading = false
        var selectedType: Asset.TypeEnum = Asset.TypeEnum.other
        
        func refreshAssetPrices(portfolio: Portfolio) async {
            let remoteAssets = portfolio.staleAssets
            
            if remoteAssets.isEmpty {
                return
            }

            isLoading = true
            defer { isLoading = false }
            
            let assetsDTO = await AssetFetcherService.shared.fetchAssets(keys: remoteAssets.map(\.key))
            for assetDTO in assetsDTO {
                if assetDTO.symbol != "ERR" {
                    remoteAssets.first(where: { $0.symbol == assetDTO.symbol })?.updateFromRemote(remoteAsset: assetDTO)
                }
            }
        }
    }
}
