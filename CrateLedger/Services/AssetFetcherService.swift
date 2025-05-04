//
//  PriceFetcherService.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 26/04/2025.
//

import Foundation

class AssetFetcherService {
    static let shared = AssetFetcherService()
    
    private let baseURL = URL(string: "http://localhost:3000")!
    
    private init() { }
    
    // Fetch multiple assets by keys
    func fetchAssets(keys: [String]) async -> [AssetDTO] {
        do {
            var urlComponents = URLComponents(string: baseURL.appendingPathComponent("assets/query").absoluteString)!
            urlComponents.queryItems = [
                URLQueryItem(name: "keys", value: keys.joined(separator: ","))
            ]
            let url = urlComponents.url!

            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Server JSON:\n\(jsonString)")
            }
            let decoder = JSONDecoder()
            let items = try decoder.decode([AssetDTO].self, from: data)

            return items
        } catch {
            // if we're still here it means the request failed somehow
            print("Failed to fetch assets: \(error.localizedDescription)")
        }
        
        return [AssetDTO(name: "Error", type: "error", price: 0.0, symbol: "ERR")]
    }
    
    // Fetch a single asset by key
    func fetchAsset(key: String) async -> AssetDTO {
        let url = baseURL.appendingPathComponent("assets/\(key)")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let item = try decoder.decode(AssetDTO.self, from: data)

            return item
        } catch {
            // if we're still here it means the request failed somehow
            print("Failed to fetch asset: \(error.localizedDescription)")
        }
        return AssetDTO(name: "Error", type: "error", price: 0.0, symbol: "ERR")
    }
}

struct AssetDTO: Codable {
    let name: String
    let type: String
    let price: Double
    let symbol: String
    var image: String?
}
