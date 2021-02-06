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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(wkWebView)

        downloadZip()
    }
    
   

    
    /// 加载html
    /// - Parameter path: html 路径
    func loadWeb(localHtmlPath path: String){
        let pathUrl = URL(fileURLWithPath: path)
        let request = URLRequest(url:pathUrl)
        DispatchQueue.main.async {
            self.wkWebView.load(request)
        }
        
    }
    
    
    
    func downloadZip() {
        let zipUrlStr = "http://139.199.87.192/resource/www.zip"
        let url = URL(string: zipUrlStr)
        guard let zipUrl = url else { return  }
        
        let md5 = (zipUrlStr as NSString).md5()
        
        let zipPath = tempZipPath(md5)
        print("zipPath=",zipPath)

        guard let unzipPath = tempUnzipPath(md5) else {
            return
        }
        print("unZipPath=",unzipPath)
        
        
        

        
        let isFileExists = FileManager.default.fileExists(atPath: unzipPath)
        
        //文件不存在进行下载
        if isFileExists {
            
          loadWeb(localHtmlPath: webPath(unzipPath))
            
        } else {
            let globalQueue = DispatchQueue.global()
            globalQueue.async {
                if let  data = try? NSData(contentsOf: zipUrl, options: .alwaysMapped) {
                    let isSaveSuccess =  data.write(toFile: zipPath, atomically: true)
                    
                    if isSaveSuccess {
                        print("Save Success")
                        let isUnzipSuccess = SSZipArchive.unzipFile(atPath: zipPath, toDestination: unzipPath, overwrite: true, password: nil, progressHandler: nil, completionHandler: nil)
                        if isUnzipSuccess {
                            print("Success unzip")
                            self.loadWeb(localHtmlPath: self.webPath(unzipPath))
                            do {
                                //解压完成 删除压缩包
                                try FileManager.default.removeItem(atPath: zipPath)
                            }catch{

                            }
                        } else {
                            print("No success unzip")
                        }
                    }else{
                        print("Save Fail")
                    }
                }
            }
        }
    }
    
}

extension DownLoadViewController{
    
    /// 下载zip的文件路径
    /// - Parameter fileName: 文件名 一般md5
    /// - Returns:
    func tempZipPath(_ fileName: String) -> String {
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        path += "/zipDownload" + "/\(fileName).zip"
        return path
    }

    
    /// zip解压目录
    /// - Parameter fileName: 文件名 一般md5
    /// - Returns:
    func tempUnzipPath(_ fileName: String) -> String? {
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        path += "/zipDownload" + "/\(fileName)"
        let url = URL(fileURLWithPath: path)
        return url.path
    }
    
    
    /// 文件目录转换成html目录
    /// - Parameter filePath: 文件目录
    /// - Returns:
    func webPath(_ filePath: String) -> String {
        let subPaths = FileManager.default.subpaths(atPath: filePath)
        let webPath = filePath + "/\(subPaths!.first!)" + "/index.html"
        return webPath
    }
    
}
