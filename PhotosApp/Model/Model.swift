//
//  Model.swift
//  PhotosApp
//
//  Created by Ashish Kheveria on 18/04/24.
//

import Foundation
import UIKit

struct Photo: Identifiable, Decodable {
    var id: String
    var alt_description: String?
    var urls: [String: String]
}

class UnsplashData: ObservableObject {
    @Published var photoArray: [Photo] = []
    private let imageDownloader = ImageDownloader()
    private let imageCache = ImageCache()
    private var page = 1 // Initial page number
    private var isLoading = false // Flag to prevent multiple simultaneous requests
    private var addedPhotoIDs: Set<String> = [] // Set to store IDs of photos that have already been added
    
    init() {
        loadData()
    }
    
    func loadData() {
        let key = "eOMpqB3ouhenJgxOwEtE41K2wXDDZoqwPJ2819zK1aI"
        let perPage = 30
        let url = "https://api.unsplash.com/photos/?page=\(page)&per_page=\(perPage)&client_id=\(key)"
        
        let session = URLSession(configuration: .default)
        
        isLoading = true // Set loading flag to true before making the request
        
        session.dataTask(with: URL(string: url)!) { (data, _, error) in
            guard let data = data else {
                print("URLSession dataTask error:", error ?? nil)
                return
            }
            
            // Print the data as a string for inspection
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON String:", jsonString)
            } else {
                print("Failed to convert data to string")
            }
            
            do {
                let json = try JSONDecoder().decode([Photo].self, from: data)
                print("**************** JSON RESPONSE **********************", json)
                DispatchQueue.main.async {
                    // Filter out duplicate photos and photos with missing thumb URLs
                    let validImages = json.filter { photo in
                        if let thumbURL = photo.urls["thumb"], !self.addedPhotoIDs.contains(photo.id) {
                            self.addedPhotoIDs.insert(photo.id)
                            return true
                        }
                        return false
                    }
                    self.photoArray.append(contentsOf: validImages)
                    self.isLoading = false // Reset loading flag after fetching data
                    self.page += 1 // Increment page number for the next request
                }
            } catch {
                print("Catched", error.localizedDescription)
            }
        }.resume()
    }
    
    func loadMoreIfNeeded(currentPhoto photo: Photo) {
        // Check if the current photo is the last photo in the array
        if let lastIndex = photoArray.firstIndex(where: { $0.id == photo.id }), lastIndex == photoArray.count - 1 {
            // Fetch more data if the last photo is visible
            if !isLoading {
                loadData()
            }
        }
    }
}
