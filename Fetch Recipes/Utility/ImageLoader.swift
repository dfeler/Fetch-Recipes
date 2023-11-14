//
//  ImageLoader.swift
//  Fetch Recipes
//
//  Created by Daniel Feler on 11/13/23.
//

import UIKit
import SwiftUI

//singleton class for caching images
class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()

    private init() {}

    //retrieve an image from the cache using a key
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    //cache an image using a key
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

//asynchronously loading and displaying images
struct AsyncImageView: View {
    let url: URL?
    var placeholder: Color
    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image = self.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle().fill(placeholder)
            }
        }
        .onAppear {
            guard let url = url else { return }
            let urlString = url.absoluteString
            loadImage(fromURL: urlString) { fetchedImage in
                self.image = fetchedImage
            }
        }
    }
}

func loadImage(fromURL urlString: String, completion: @escaping (UIImage?) -> Void) {
    if let cachedImage = ImageCache.shared.getImage(forKey: urlString) {
        completion(cachedImage)
        return
    }

    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    //perform image loading on a background thread
    DispatchQueue.global().async {
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            ImageCache.shared.setImage(image, forKey: urlString)
            DispatchQueue.main.async {
                completion(image)
            }
        } else {
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
}
