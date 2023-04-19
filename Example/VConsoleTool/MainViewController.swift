//
//  MainViewController.swift
//  Test_URL
//
//  Created by 吴添培 on 2023/3/31.
//

import UIKit
import WebKit
import VConsoleTool

class MainViewController: UIViewController {
    
    var loadUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(jsView)

        if let url = URL(string: "https://www.baidu.com") {
            jsView.load(URLRequest(url: url))
            
        }

       
    }
  
    lazy var jsView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        
        if let script = VConsoleTool.shared.loadVConsoleScript() {
            configuration.userContentController.addUserScript(script)
        }
        
        let jsv = WKWebView.init(frame: UIScreen.main.bounds, configuration: configuration)
        jsv.navigationDelegate = self
        jsv.uiDelegate = self

        return jsv
    }()

    deinit {
        jsView.configuration.userContentController.removeAllUserScripts()
       

    }

}

extension MainViewController: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if ((navigationAction.targetFrame?.isMainFrame) == nil) {
            webView.load(navigationAction.request)
        }
        
        decisionHandler(.allow)
        
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if ((navigationAction.targetFrame?.isMainFrame) == nil) {
            webView.load(navigationAction.request)
        }
        
        return nil
        
    }
    
    //开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // 可以在这里做正在加载的提示动画 然后在加载完成代理方法里移除动画
    }
    
    //网络错误
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        //在这里可以做错误提示
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //禁止h5缩放
        let anotherjs = "var metaEle = document.createElement(\"meta\"); metaEle.setAttribute(\"name\",\"viewport\"); metaEle.setAttribute(\"content\",\" width=device-width, initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0, user-scalable=no \");document.getElementsByTagName('head')[0].appendChild(metaEle);"
        webView.evaluateJavaScript(anotherjs)
  
    }
    
    // alert
    //此方法作为js的alert方法接口的实现，默认弹出窗口应该只有提示信息及一个确认按钮，当然可以添加更多按钮以及其他内容，但是并不会起到什么作用
    //点击确认按钮的相应事件需要执行completionHandler，这样js才能继续执行
    ////参数 message为  js 方法 alert(<message>) 中的<message>
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController.init(title: "提示", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .default) { _ in completionHandler() })
        present(alertController, animated: true)
        
    }
    
    // confirm
    //作为js中confirm接口的实现，需要有提示信息以及两个相应事件， 确认及取消，并且在completionHandler中回传相应结果，确认返回YES， 取消返回NO
    //参数 message为  js 方法 confirm(<message>) 中的<message>
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alertController = UIAlertController.init(title: "提示", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel) { _ in completionHandler(false) })
        alertController.addAction(UIAlertAction(title: "确定", style: .default) { _ in completionHandler(true) })
        present(alertController, animated: true)
        
    }
    
    // prompt
    //作为js中prompt接口的实现，默认需要有一个输入框一个按钮，点击确认按钮回传输入值
    //当然可以添加多个按钮以及多个输入框，不过completionHandler只有一个参数，如果有多个输入框，需要将多个输入框中的值通过某种方式拼接成一个字符串回传，js接收到之后再做处理
    //参数 prompt 为 prompt(<message>, <defaultValue>);中的<message>
    //参数defaultText 为 prompt(<message>, <defaultValue>);中的 <defaultValue>
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController.init(title: prompt, message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = defaultText
        }
        alertController.addAction(UIAlertAction(title: "完成", style: .default) { _ in
            completionHandler(alertController.textFields?.first?.text)
            
        })
        present(alertController, animated: true)
        
    }
  
}
 
        
        
        
        
        
        
        
        
     
