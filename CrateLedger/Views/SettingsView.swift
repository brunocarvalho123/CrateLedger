//
//  SettingsView.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 12/05/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("preferredCurrency") var preferredCurrency: String = "USD"
    @AppStorage("privacyMode") var privacyMode: Bool = false

    @State private var showExportSheet = false
    @State private var showImportSheet = false
    @State private var showClearDataAlert = false

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("General")) {
                    Picker("Currency", selection: $preferredCurrency) {
                        ForEach(["USD", "EUR", "BTC"], id: \.self) { currency in
                            Text(currency)
                        }
                    }

                    Toggle("Privacy mode", isOn: $privacyMode)
                }

                Section(header: Text("Data")) {
                    Button("Export Data") {
                        showExportSheet = true
                        // Implement export logic here
                    }

                    Button("Import Data") {
                        showImportSheet = true
                        // Implement import logic here
                    }

                    Button("Clear All Data", role: .destructive) {
                        showClearDataAlert = true
                    }
                }

                Section(header: Text("Support")) {
                    Button("Upgrade to Pro") {
                        // Show StoreKit paywall or tip jar view
                    }

                    HStack {
                        Text("App Version")
                        Spacer()
                        Text(appVersion)
                            .foregroundStyle(Color.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Are you sure you want to delete all data?", isPresented: $showClearDataAlert) {
                Button("Delete All Data", role: .destructive) {
                    clearAllData()
                }
            }
        }
    }

    func clearAllData() {
        // Add real delete logic here, e.g., wiping SwiftData store or deleting user files
        print("All data cleared.")
    }
}

#Preview {
    SettingsView()
}
