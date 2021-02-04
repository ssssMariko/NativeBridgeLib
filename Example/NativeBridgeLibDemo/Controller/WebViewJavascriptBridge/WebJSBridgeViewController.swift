//
//  WebJSBridgeViewController.swift
//  NativeBridgeLibDemo
//
//  Created by Mariko0Oo on 2021/2/4.
//

import UIKit

class WebJSBridgeViewController: UIViewController {

    var bridge: WebViewJavascriptBridge?
    
    lazy var wkWebView: WKWebView = {
        let view = WKWebView(frame: self.view.bounds)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(wkWebView)

        let path = Bundle.main.path(forResource: "ExampleApp.html", ofType: nil)
        guard let filePath = path else { return  }
        
        let pathUrl = URL(fileURLWithPath: filePath)
        let request = URLRequest(url:  pathUrl)
        wkWebView.load(request)
        
        WebViewJavascriptBridge.enableLogging()
        //Instantiate WebViewJavascriptBridge
        bridge = WebViewJavascriptBridge(forWebView: wkWebView)
        
        //Register a handler in ObjC, and call a JS handler
        bridge?.registerHandler("testObjcCallback"){ (data, responseCallback) in
            print("testObjcCallback called:" , data)
            responseCallback!("Response from testObjcCallback")
        }
        
        
        bridge?.callHandler("testJavascriptHandler", data: ["greetingFromObjC":"Hi there, JS!"]){ responseData in
            print("testJavascriptHandler responded: " , responseData)

        }
    }
    


}
