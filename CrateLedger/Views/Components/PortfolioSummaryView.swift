//
//  PortfolioSummaryView.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 26/04/2025.
//

import SwiftUI
import SwiftData
import Charts

struct PortfolioSummaryView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var portfolio: Portfolio

    var body: some View {
        VStack {
            Chart(Asset.TypeEnum.allCases) { assetType in
                SectorMark(
                    angle: .value("Value", portfolio.valueIn(types: [assetType])),
                    innerRadius: .ratio(0.5),
                    angularInset: 1.5
                )
                .foregroundStyle(assetType.color)
            }
            .frame(height: 150)

            Text(portfolio.value.formatted(.currency(code: "USD")))
                .font(.title)
                .bold()
                .padding(.top, 14)
        }
        .padding(.top)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Portfolio.self, configurations: config)
        let portfolio = Portfolio.example()
        return PortfolioSummaryView(portfolio: portfolio)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}

