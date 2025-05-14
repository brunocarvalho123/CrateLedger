//
//  NoSearchQuery.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 12/05/2025.
//

import SwiftUI

struct NoSearchQuery: View {
    var type: Asset.TypeEnum?
    
    var body: some View {
        ContentUnavailableView {
            switch type {
            case .crypto:
                Label("Add cryto", systemImage: type?.systemImage ?? "plus.circle")
            case .stock:
                Label("Add stock", systemImage: type?.systemImage ?? "plus.circle")
            case .etf:
                Label("Add ETF", systemImage: type?.systemImage ?? "plus.circle")
            case .metal:
                Label("Add precious metal", systemImage: type?.systemImage ?? "plus.circle")
            case .cash:
                Label("Add cash", systemImage: type?.systemImage ?? "plus.circle")
            default:
                Label("Add assets", systemImage: "plus.circle")
            }
        } description: {
            switch type {
            case .crypto,.stock,.etf,.metal,.cash,nil:
                Text("Type in an asset symbol or name to start searching!")
            default:
                Text("Type in the asset name to create it")
            }
            
        }
        .padding()
    }
}

#Preview {
    NoSearchQuery()
}
