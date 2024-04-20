# PhotosApp - Unsplash API

## Overview

PhotosApp is an iOS application developed using Swift that efficiently loads and displays images in a scrollable grid. It utilizes the Unsplash API to fetch images asynchronously and implements a caching mechanism for efficient retrieval.

## Features

- **Image Loading:** Images are loaded asynchronously from the Unsplash API URLs to ensure smooth scrolling performance, even with a large number of images.
  
- **Caching:** A caching mechanism is implemented to store images retrieved from the API in memory, enhancing performance by avoiding redundant network requests.

- **Error Handling:** The app gracefully handles network errors and image loading failures, providing informative error messages or placeholders for failed image loads.

## Project Structure

- **Common:** Contains classes responsible for image loading, downloading, and caching (`ImageLoader.swift`, `ImageDownloader.swift`, `ImageCache.swift`).

- **Views:** Contains SwiftUI views, including the main content view (`ContentView.swift`) and the async image view (`AsyncImageView.swift`).

- **Model:** Contains the model file (`Model.swift`), defining the `Photo` struct and the `UnsplashData` class responsible for fetching data from the Unsplash API.

## How It Works

1. **Image Loading:**
   - The `UnsplashData` class fetches images asynchronously from the Unsplash API using URLSession data tasks.
   - Images are displayed in a scrollable grid using SwiftUI's LazyVGrid and ForEach constructs.

2. **Caching:**
   - The `ImageCache` class stores images retrieved from the API in memory using NSCache, enhancing performance by avoiding redundant network requests.
   - The `ImageLoader` class loads images from the cache if available, otherwise downloads them from the API and saves them to the cache for future use.

3. **Error Handling:**
   - Network errors and image loading failures are gracefully handled using error handling mechanisms in URLSession data tasks.
   - Placeholder images or informative error messages are displayed for failed image loads.

## Running the App

1. Clone the repository.
2. Open the project in Xcode.
3. Build and run the app on a simulator or device.
