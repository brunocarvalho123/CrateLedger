//
//  SearchResultRow.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 12/05/2025.
//

import SwiftUI

struct SearchResultRow: View {
    var result: SearchResult
    
    var resultType: Asset.TypeEnum {
        Asset.TypeEnum.from(raw: result.type)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(result.name)
                Text(result.symbol.uppercased())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .center) {
                Image(systemName: resultType.systemImage)
                Text(resultType.displayName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 55)            
        }
    }
}

#Preview {
    SearchResultRow(result: SearchResult(name: "Test Asset Name", symbol: "TEST", type: "stock"))
}
