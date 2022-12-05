//
//  VideoView.swift
//  AVFoundation_Audio
//
//  Created by Наталья Босякова on 05.12.2022.
//

import WebKit
import SwiftUI

class VideoView: UIViewController, WKNavigationDelegate {
    
    var stringURL: String
    
    var webView: WKWebView
    
    init(url: String) {
        self.webView = WKWebView()
        self.stringURL = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.webView.navigationDelegate = self
        self.webView.scrollView.isScrollEnabled = false
        self.webView.load(URLRequest(url: URL(string: stringURL)!))
        
        view = webView
    }
}
