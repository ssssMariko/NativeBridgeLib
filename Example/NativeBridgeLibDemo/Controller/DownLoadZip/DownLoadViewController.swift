//
//  DownLoadViewController.swift
//  NativeBridgeLibDemo
//
//  Created by Mariko0Oo on 2021/2/6.
//

import UIKit
import WebKit

class DownLoadViewController: UIViewController {
    
    lazy var wkWebView: WKWebView = {
        let view = WKWebView(frame: self.view.bounds)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var progressView:UIProgressView = {
        let view = UIProgressView(progressViewStyle: .bar)
        view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 3)
        return view
    }()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(wkWebView)
        self.view.addSubview(progressView)

        WebResourceManager.getWebResource(
            withUrl: "http://139.199.87.192/resource/www.zip",
            progressView:progressView,
            progress: nil) { (url, error) in
                if let webUrl = url {
                    DispatchQueue.main.async {
                        let request = URLRequest(url:webUrl)
                        self.wkWebView.load(request)
                    }
                }
        }

    }
    
    deinit {
        
    }

}
