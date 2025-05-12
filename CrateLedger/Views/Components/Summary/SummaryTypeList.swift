//
//  SummaryTypeList.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 07/05/2025.
//

import SwiftUI

struct SummaryTypeList: View {
    var portfolio: Portfolio

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
                            
                            Spacer()

                            Circle()
                                .fill(type.color)
                                .frame(width: 10, height: 10)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SummaryView(portfolio: Portfolio.example())
}
