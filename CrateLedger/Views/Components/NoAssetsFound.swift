//
//  NoAssetsFound.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 16/05/2025.
//

import SwiftUI

struct NoAssetsFound: View {
    @Binding var showingAddScreen: Bool
    
    var body: some View {
        ContentUnavailableView {
            Label("Start Tracking Your Assets", systemImage: "chart.bar.fill")
        } description: {
            Text("Your portfolio is empty. Add your first asset to see its value and performance.")
        } actions: {
            Button("Add your first asset") {
                showingAddScreen = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
//    NoAssetsFound()
}
