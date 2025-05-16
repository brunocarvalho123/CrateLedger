//
//  AllAssetsView.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 13/05/2025.
//

import SwiftUI

struct AllAssetsView: View {
    @Bindable var portfolio: Portfolio
    
    @State var showingAddScreen = false
    
    var body: some View {
        NavigationStack {
            if portfolio.hasAssets {
                AssetList(portfolio: portfolio)
            } else {
                NoAssetsFound(showingAddScreen: $showingAddScreen)
                .sheet(isPresented: $showingAddScreen) {
                    SearchView(portfolio: portfolio, type: nil)
                }
            }
        }
    }
}

#Preview {
    AllAssetsView(portfolio: Portfolio.example())
}
