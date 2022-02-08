//
//  DetailNewsVC.swift
//  SportNewsApp
//
//  Created by Mac on 26/01/2022.
//

import UIKit
import WebKit
import RealmSwift

class DetailNewsVC: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    // MARK: Properties
    var selectedArticle = ArticleRealm()
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    lazy var webView: WKWebView = {
        guard let path = Bundle.main.path(forResource: "style", ofType: "css") else {
            return WKWebView()
        }
        
        let cssString = try! String(contentsOfFile: path).components(separatedBy: .newlines).joined()
        let source = """
        var style = document.createElement('style');
        style.innerHTML = '\(cssString)';
        document.head.appendChild(style);
        """
        
        let userScript = WKUserScript(source: source,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: true)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        let webView = WKWebView(frame: .zero,
                                configuration: configuration)
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        return webView
    }()
    
    var webViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let html = selectedArticle.fullDescr ?? "Article not found"
        print(html)
        loadHTMLContent(html)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            self.setupSubviews()
        }
    }
    
    // MARK: Helper methods
    
    private func loadHTMLContent(_ htmlContent: String) {
        
        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></HEAD><BODY>"
        let htmlEnd = "</BODY></HTML>"
        let htmlString = "\(htmlStart)\(htmlContent)\(htmlEnd)"
        
        if htmlContent.contains("platform.twitter.com/widgets.js") {
            let twitterJS: String = "window.twttr = (function(d, s, id) {var js, fjs = d.getElementsByTagName(s)[0],t = window.twttr || {};if (d.getElementById(id)) return t;js = d.createElement(s);js.id = id;js.src = \"https://platform.twitter.com/widgets.js\";fjs.parentNode.insertBefore(js, fjs);t._e = [];t.ready = function(f) {t._e.push(f);};return t;}(document, \"script\", \"twitter-wjs\"));twttr.ready(function (twttr) {twttr.events.bind('loaded', function (event) {window.webkit.messageHandlers.callbackHandler.postMessage('TWEET');});});"
            let userScript = WKUserScript(source: twitterJS, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            webView.configuration.userContentController.removeAllUserScripts()
            webView.configuration.userContentController.addUserScript(userScript)
            webView.configuration.userContentController.add(self, name: "callbackHandler")
        }
        webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "callbackHandler" {
            //            print(message.body)
            webView.evaluateJavaScript("document.body.offsetHeight", completionHandler: { (height, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let height = height as? CGFloat{
                    guard let constant = self.webViewHeightConstraint?.constant else { return }
                    if height > constant {
                        self.webViewHeightConstraint?.constant = height
                    }
                    
                }
            })
        }
    }
    
    // MARK: WKNavigationDelegate methods
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
            self.webViewHeightConstraint?.constant = height as! CGFloat
        })
    }
    
    func setupSubviews() {
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        contentView.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        topView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        topView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        webViewHeightConstraint = webView.heightAnchor.constraint(equalToConstant: 200)
        
        
        contentView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10).isActive = true
        webView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        webView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        webViewHeightConstraint = webView.heightAnchor.constraint(equalToConstant: 200)
        webViewHeightConstraint?.isActive = true
    }
}
