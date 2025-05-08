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
    var portfolio: Portfolio

    var body: some View {
        VStack {
            Chart(Asset.TypeEnum.allCases) { assetType in
                SectorMark(
                    angle: .value("Value", portfolio.valueIn(types: [assetType])),
                    innerRadius: .ratio(0.44),
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
    PortfolioSummaryView(portfolio: Portfolio.example())
}

