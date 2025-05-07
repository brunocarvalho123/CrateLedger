//
//  TypeListView.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 07/05/2025.
//

import SwiftUI
import SwiftData

struct TypeList: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var portfolio: Portfolio

    var body: some View {
        List {
            ForEach(Asset.TypeEnum.allCases) { type in
                if portfolio.valueIn(type: type) > 0 {
                    NavigationLink(value: type) {
                        HStack {
                            Image(systemName: type.systemImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 26, height: 26)
                                .padding(.trailing, 10)
                            
                            VStack(alignment: .leading) {
                                Text(type.displayName)
                                    .font(.headline)
                                Text(portfolio.valueIn(type: type), format: .currency(code: "USD"))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Portfolio.self, configurations: config)
        let portfolio = Portfolio.example()
        return PortfolioView(portfolio: portfolio)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
