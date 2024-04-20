//
//  Common.swift
//  PhotosApp
//
//  Created by Ashish Kheveria on 18/04/24.
//

import Foundation
import UIKit

class ImageLoader: ObservableObject {
    private let imageCache = ImageCache()
    
    func loadImageFromCache(url: URL) -> UIImage? {
        let urlString = url.absoluteString
        if let cachedImage = imageCache.getImage(forKey: urlString) {
            print("Image loaded from cache:", urlString)
            return cachedImage
        }
        return nil
    }
    
    func downloadImage(from url: URL, completion: @escaping (Data?) -> Void) {
        let urlString = url.absoluteString
        
        // Attempt to load the image from cache
        if let cachedImage = loadImageFromCache(url: url) {
            print("Image loaded from cache:", urlString)
            DispatchQueue.main.async {
                completion(cachedImage.pngData()) // Convert UIImage to Data and pass it to the completion handler
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error {
                    print("Error downloading image:", error.localizedDescription)
                } else {
                    print("Error downloading image: Unknown error")
                }
                completion(nil)
                return
            }
            print("Image downloaded:", urlString)
            self.imageCache.saveImage(UIImage(data: data)!, forKey: urlString) // Save the downloaded image to cache
            completion(data)
        }.resume()
    }
}

class ImageDownloader {
    func downloadImage(from url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(data)
        }.resume()
    }
}

class ImageCache {
    private let cache = NSCache<NSString, UIImage>()

    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func saveImage(_ image: UIImage, forKey key: String) {
        print("Saving image in cache")
        cache.setObject(image, forKey: key as NSString)
    }
}
