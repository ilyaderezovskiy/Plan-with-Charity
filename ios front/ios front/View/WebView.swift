//
//  WebView.swift
//  ios front
//
//  Created by Ilya Derezovskiy on 08.04.2023.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var url: URL
    
    init (link: URL) {
        self.url = link
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
