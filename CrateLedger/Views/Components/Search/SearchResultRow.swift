//
//  SearchResultRow.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 12/05/2025.
//

import SwiftUI

struct SearchResultRow: View {
    var asset: SearchResult
    
    var assetType: Asset.TypeEnum {
        Asset.TypeEnum.from(raw: asset.type)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(asset.name)
                Text(asset.symbol.uppercased())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .center) {
                Image(systemName: assetType.systemImage)
                Text(assetType.displayName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 55)            
        }
    }
}

#Preview {
    SearchResultRow(asset: SearchResult(name: "Test Asset Name", symbol: "TEST", type: "stock"))
}
