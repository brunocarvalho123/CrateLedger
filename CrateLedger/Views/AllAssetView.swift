//
//  AllAssetsView.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 13/05/2025.
//

import SwiftUI

struct AllAssetsView: View {
    @Bindable var portfolio: Portfolio
    
    var body: some View {
        NavigationStack {
            AssetList(portfolio: portfolio)
        }
    }
}

#Preview {
    AllAssetsView(portfolio: Portfolio.example())
}
