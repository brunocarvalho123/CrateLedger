//
//  AssetListView.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 13/05/2025.
//

import SwiftUI

struct AssetListView: View {
    @Bindable var portfolio: Portfolio
    
    var body: some View {
        NavigationStack {
            AssetList(portfolio: portfolio)
                .navigationTitle("Assets")
        }
    }
}

#Preview {
    AssetListView(portfolio: Portfolio.example())
}
