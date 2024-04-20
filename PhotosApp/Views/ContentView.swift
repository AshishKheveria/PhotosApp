//
//  ContentView.swift
//  PhotosApp
//
//  Created by Ashish Kheveria on 18/04/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var randomImages = UnsplashData()
    
    var columns = [
        GridItem(spacing: 0),
        GridItem(spacing: 0),
        GridItem(spacing: 0)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(randomImages.photoArray.indices, id: \.self) { index in
                        let photo = randomImages.photoArray[index]
                        AsyncImageView(url: URL(string: photo.urls["thumb"]!)!)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                            .onAppear {
                                // Check if the current photo is the last photo visible
                                randomImages.loadMoreIfNeeded(currentPhoto: photo)
                            }
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Photos")
        }
        
        
    }
}


#Preview {
    ContentView()
}

