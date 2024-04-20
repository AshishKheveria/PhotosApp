//
//  AsyncImageView.swift
//  PhotosApp
//
//  Created by Ashish Kheveria on 19/04/24.
//

import Foundation
import SwiftUI


struct AsyncImageView: View {
    @ObservedObject private var imageLoader = ImageLoader()
    @State private var image: UIImage?
    
    let url: URL
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView() // Placeholder while loading
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        if let cachedImage = imageLoader.loadImageFromCache(url: url) {
            image = cachedImage
        } else {
            imageLoader.downloadImage(from: url) { imageData in
                guard let imageData = imageData, let uiImage = UIImage(data: imageData) else { return }
                DispatchQueue.main.async {
                    image = uiImage
                }
            }
        }
    }
}

