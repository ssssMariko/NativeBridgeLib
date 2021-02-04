//
//  WebViewController.swift
//  NativeBridgeLibDemo
//
//  Created by Mariko0Oo on 2021/2/4.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    lazy var wkWebView: WKWebView = {
        let view = WKWebView(frame: self.view.bounds)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(wkWebView)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //开始监听缓存数据
        ZFJCacheProtocol.startMonitorRequest(ZFJCacheType.allType)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //在不需要用到webview的时候即使的取消监听
        ZFJCacheProtocol.cancelMonitorRequest()
    }

    /// 加载网络url
    @IBAction func loadHttpWeb(_ sender: Any) {
        let url = "https://image.baidu.com"
        let request = URLRequest(url: URL(string: url)!)
        wkWebView.load(request)
    }

    ///加载本地html
    @IBAction func loadLocalWeb(_ sender: Any) {
        let path = Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "www")
        guard let filePath = path else { return  }
        let pathUrl = URL(fileURLWithPath: filePath)
        let request = URLRequest(url:  pathUrl)
        wkWebView.load(request)
    }

}
