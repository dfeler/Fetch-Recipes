//
//  YouTubeVideoPlayerView.swift
//  Fetch Recipes
//
//  Created by Daniel Feler on 11/10/23.
//

import SwiftUI
import WebKit

struct YouTubeVideoPlayer: View {
    var youtubeURL: String

    var body: some View {
        YouTubeView(youtubeURL: convertToEmbedURL(youtubeURL))
            .frame(height: 260)
            .cornerRadius(10)
            .padding()
    }

    //convert a YouTube URL to an embed URL
    private func convertToEmbedURL(_ url: String) -> String {
        if let range = url.range(of: "(?<=watch\\?v=|youtu.be/)[^&#]+", options: .regularExpression) {
            let videoID = String(url[range])
            return "https://www.youtube.com/embed/\(videoID)"
        }
        return url
    }
}

struct YouTubeView: UIViewRepresentable {
    var youtubeURL: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: youtubeURL) else { return }
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
