//
//  NoSearchQuery.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 12/05/2025.
//

import SwiftUI

struct NoSearchQuery: View {
    var body: some View {
        ContentUnavailableView {
            Label("Search assets", systemImage: "magnifyingglass")
        } description: {
            Text("Type in an asset symbol or name to start searching!")
        }
        .padding()
    }
}

#Preview {
    NoSearchQuery()
}
