//
//  AssetImage.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 15/05/2025.
//

import SwiftUI
import PhotosUI

struct AssetImage: View {
    @Bindable var asset: Asset
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isShowingPhotoPicker = false
    
    let frameWidth: CGFloat = 120
    let frameHeight: CGFloat = 70
    let shape = RoundedRectangle(cornerRadius: 8)
    
    var body: some View {
        if asset.hasImage && asset.isRemoteImage {
            AsyncImage(url: asset.imageURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: frameWidth, height: frameHeight)
                        .clipShape(shape)
                } else if phase.error != nil {
                    // Error
                } else {
                    // Placeholder
                    ProgressView()
                }
            }
            .frame(width: frameWidth, height: frameHeight)
        } else {
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                if asset.hasImage, let url = asset.imageURL, let uiImage = UIImage(contentsOfFile: url.path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: frameWidth, height: frameHeight)
                        .clipShape(shape)
                } else {
                    // Fallback if file is missing
                    VStack {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 28))
                            .foregroundStyle(Color.blue)
                    }
                    .frame(width: frameWidth, height: frameHeight)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(shape)
                }
            }
            .onChange(of: selectedPhoto) {
                Task {
                    guard let imageData = try await selectedPhoto?.loadTransferable(type: Data.self) else { return }
                    guard let uiImage = UIImage(data: imageData) else { return }
                    saveImageToDocuments(uiImage, asset: asset)
                }
            }
        }
    }

    func saveImageToDocuments(_ image: UIImage, asset: Asset) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let filename = UUID().uuidString + ".jpg"
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)
        
        do {
            try data.write(to: url)
            if asset.hasImage && asset.isRemoteImage == false {
                deletePreviousImage(path: asset.image)
            }
            asset.image = url.path
        } catch {
            print("Failed to save image: \(error)")
        }
    }
    
    func deletePreviousImage(path: String) {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch {
            print("Error deleting previous image: \(error)")
        }
    }
}

#Preview {
    AssetImage(asset: Asset.example())
}
