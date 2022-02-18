//
//  DetailNews2.swift
//  SportNewsApp
//
//  Created by Mac on 14/02/2022.
//

import UIKit
import WebKit
import RealmSwift

class DetailNews2VC: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    // MARK: Properties
    //var selectedArticle = ArticleRealm()
    //  ***********  ***********  ***********  ***********
    // MARK: Properties
    var selectedArticle = ArticleRealm() {
        didSet {
            
            let article = selectedArticle
            
            let dateArticle = article.timeAndDate
            let timeDateToDisplay = StorageManager.formatMyDateTime(yourDateTime: dateArticle)
            titleLabel.text = article.title
            dateTimePublicatedLabel.text = timeDateToDisplay
            authorNameLabel.text = "Artur Pirajcov"
            visualizatIonNumbersLabel.text = String(getVisualizations())
            commentsIonNumbersLabel.text = String(getVisualizations())
            
            func getVisualizations() -> Int {
                let visualizations: Int = Int(arc4random_uniform(10000))
                return visualizations
            }

            DispatchQueue.main.async { [self] in
                title1Button = newsPostsRealm[5].title
                title2Button = newsPostsRealm[1].title
                title3Button = newsPostsRealm[2].title
                title4Button = newsPostsRealm[3].title
                title5Button = newsPostsRealm[4].title
                
                title1CurrentButton = newsPostsRealm[6].title
                title2CurrentButton = newsPostsRealm[7].title
                title3CurrentButton = newsPostsRealm[8].title
                title4CurrentButton = newsPostsRealm[9].title
                title5CurrentButton = newsPostsRealm[10].title
            }

        }
    }
    //  ***********  ***********  ***********  ***********
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
    //  ***********  ***********  ***********  ***********
    // Top view
    let topTitleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let srticleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var stackViewVisualisation: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    lazy var stackViewSecond: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    lazy var view1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var view2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var view3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Author:"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let authorNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .greenMain()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateTimeimageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.image?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .lightGray
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "clock")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let dateTimePublicatedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let visualizationImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.image?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .lightGray
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "eye")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let visualizatIonNumbersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)//UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let commentsImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.image?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .lightGray
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "message")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let commentsIonNumbersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)//UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //  ***********  ***********  ***********  ***********
    
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
    
    //  ***********  ***********  ***********  ***********
    // top news view
    let titleLatestNewsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.text = "LATEST NEWS"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let underlineBrokenLineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "----------------------------------------------------------------------------------------------------------------------------------------"
        //label.font = UIFont.boldSystemFont(ofSize: 22)
        label.lineBreakMode = .byClipping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let underline2BrokenLineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "----------------------------------------------------------------------------------------------------------------------------------------"
        //label.font = UIFont.boldSystemFont(ofSize: 22)
        label.lineBreakMode = .byClipping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let underline3BrokenLineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "----------------------------------------------------------------------------------------------------------------------------------------"
        //label.font = UIFont.boldSystemFont(ofSize: 22)
        label.lineBreakMode = .byClipping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let underline4BrokenLineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "----------------------------------------------------------------------------------------------------------------------------------------"
        //label.font = UIFont.boldSystemFont(ofSize: 22)
        label.lineBreakMode = .byClipping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let news1LatestNewsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.text = "LATEST NEWS"
        //label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    let button = UIButton(frame: CGRect(x: 20, y: 20, width: 200, height: 60))
//     button.setTitle("Email", for: .normal)
//     button.backgroundColor = .white
//     button.setTitleColor(UIColor.black, for: .normal)
//     button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
//     myView.addSubview(button)
    lazy var title1Button = ""
    lazy var title2Button = ""
    lazy var title3Button = ""
    lazy var title4Button = ""
    lazy var title5Button = ""
    
    lazy var latestNews1Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let title = title1Button
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: title1Button)
        attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.backgroundColor = .white
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
        button.tag = 1
        //button.backgroundColor = UIColor.greenMain() //set button background color
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    lazy var latestNews2Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let title = title2Button
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.backgroundColor = .white
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
//        button.backgroundColor = UIColor.greenMain() //set button background color
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.tag = 2
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    lazy var latestNews3Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let title = title3Button
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.backgroundColor = .white
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
//        button.backgroundColor = UIColor.greenMain() //set button background color
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.tag = 3
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    lazy var latestNews4Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let title = title4Button
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.backgroundColor = .white
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
//        button.backgroundColor = UIColor.greenMain() //set button background color
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.tag = 4
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    lazy var latestNews5Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let title = title5Button
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.backgroundColor = .white
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
//        button.backgroundColor = UIColor.greenMain() //set button background color
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.tag = 5
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
//    let  myImage: UIImage = {
//        var image = UIImage()
//        image = UIImage(named: "line")!
//        return image
//    }()


    @objc func buttonTapped(sender:UIButton!) {
        print("you clicked on button \(sender.tag)")
    }
    
    //  ***********  ***********  ***********  ***********
    // Current News View
    lazy var stackViewThird: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let titleCurrentNewsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.text = "CURRENT NEWS"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let underlineBrokenLineCurrentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "----------------------------------------------------------------------------------------------------------------------------------------"
        //label.font = UIFont.boldSystemFont(ofSize: 22)
        label.lineBreakMode = .byClipping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let underline2BrokenLineCurrentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "----------------------------------------------------------------------------------------------------------------------------------------"
        //label.font = UIFont.boldSystemFont(ofSize: 22)
        label.lineBreakMode = .byClipping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let underline3BrokenLineCurrentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "----------------------------------------------------------------------------------------------------------------------------------------"
        //label.font = UIFont.boldSystemFont(ofSize: 22)
        label.lineBreakMode = .byClipping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let underline4BrokenLineCurrentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "----------------------------------------------------------------------------------------------------------------------------------------"
        //label.font = UIFont.boldSystemFont(ofSize: 22)
        label.lineBreakMode = .byClipping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let news1CurrentNewsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.text = "LATEST NEWS"
        //label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var title1CurrentButton = ""
    lazy var title2CurrentButton = ""
    lazy var title3CurrentButton = ""
    lazy var title4CurrentButton = ""
    lazy var title5CurrentButton = ""
    
    lazy var currentNews1Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let title = title1Button
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: title1Button)
        attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.backgroundColor = .white
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.tag = 11
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
        
        //button.backgroundColor = UIColor.greenMain() //set button background color
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    lazy var currentNews2Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let title = title2Button
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.backgroundColor = .white
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
//        button.backgroundColor = UIColor.greenMain() //set button background color
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.tag = 12
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    lazy var currentNews3Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let title = title3Button
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.backgroundColor = .white
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
//        button.backgroundColor = UIColor.greenMain() //set button background color
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.tag = 13
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    lazy var currentNews4Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let title = title4Button
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.backgroundColor = .white
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
//        button.backgroundColor = UIColor.greenMain() //set button background color
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.tag = 14
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    lazy var currentNews5Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let title = title5Button
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.backgroundColor = .white
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
//        button.backgroundColor = UIColor.greenMain() //set button background color
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.tag = 15
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    //  ***********  ***********  ***********  ***********
    //  Articles News View
    lazy var stackViewForth: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let titleArticleNewsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.text = "ARTICLES"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let imageArticle1: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.image?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .lightGray
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "test")
        iv.backgroundColor = .blue
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let imageArticle2: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.image?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .lightGray
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "test")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var articleNews1Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let title = title5Button
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.backgroundColor = .white
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
//        button.backgroundColor = UIColor.greenMain() //set button background color
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.tag = 15
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    lazy var articleNews2Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let title = title5Button
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.backgroundColor = .white
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
//        button.backgroundColor = UIColor.greenMain() //set button background color
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.tag = 15
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "userProfileImageView")
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    //  ***********  ***********  ***********  ***********
    
    var webViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: Lifecycle methods
    var newsPostsRealm: Results<ArticleRealm>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let html = selectedArticle.fullDescr ?? "Article not found"
        loadHTMLContent(html)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            self.setupSubviews()
        }
        setupLoad()
    }
    
    private func setupLoad() {
        newsPostsRealm = realm.objects(ArticleRealm.self)
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
        scrollView.pinSafe(to: view)
        contentView.pin(to: scrollView)
        
        
        contentView.addSubview(topTitleView)
        topTitleView.translatesAutoresizingMaskIntoConstraints = false
        topTitleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        topTitleView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        topTitleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        
        //  ***********  ***********  ***********  ***********
        stackViewVisualisation.pin(to: topTitleView)
        stackViewVisualisation.VStack(view1.HStack(titleLabel,
                                           spacing: 0, alignment: .leading, distribution: .fillProportionally),
                              view1.HStack(authorLabel,
                                           authorNameLabel,
                                           spacing: 2, alignment: .leading, distribution: .fillProportionally),
                              view2.HStack( view1.HStack(dateTimeimageView,
                                                         dateTimePublicatedLabel,
                                                         spacing: 2, alignment: .leading, distribution: .fillProportionally),
                                            view1.HStack(visualizationImageView,
                                                         visualizatIonNumbersLabel,
                                                         spacing: 2, alignment: .leading, distribution: .fillProportionally),
                                            view1.HStack(commentsImageView,
                                                         commentsIonNumbersLabel,
                                                         spacing: 2, alignment: .leading, distribution: .fillProportionally),
                                            spacing: 15, alignment: .leading, distribution: .fillProportionally),
                              spacing: 15, alignment: .leading, distribution: .equalSpacing)
        //  ***********  ***********  ***********  ***********
        
        webView.pinExcludingBottom(pinTopToBottomSuperview: topTitleView, toMainSuperViewLeftRight: contentView)
        webViewHeightConstraint = webView.heightAnchor.constraint(equalToConstant: 200)
        webViewHeightConstraint?.isActive = true
        
        stackViewSecond.pinExcludingBottom(pinTopToBottomSuperview: webView, toMainSuperViewLeftRight: contentView)
        
        stackViewSecond.VStack(titleCurrentNewsLabel,
                               view1.VStack(
                                            currentNews1Button,
                                            underlineBrokenLineCurrentLabel,
                                            currentNews2Button,
                                            underline2BrokenLineCurrentLabel,
                                            currentNews3Button,
                                            underline3BrokenLineCurrentLabel,
                                            currentNews4Button,
                                            underline4BrokenLineCurrentLabel,
                                            currentNews5Button,
                                spacing: 2, alignment: .leading, distribution: .fillEqually),
                               spacing: 15, alignment: .leading, distribution: .equalSpacing)
        
        stackViewThird.pinExcludingBottom(pinTopToBottomSuperview: stackViewSecond, toMainSuperViewLeftRight: contentView)
        
        stackViewThird.VStack(titleLatestNewsLabel,
                              view1.VStack(
                                           latestNews1Button,
                                           underlineBrokenLineLabel,
                                           latestNews2Button,
                                           underline2BrokenLineLabel,
                                           latestNews3Button,
                                           underline3BrokenLineLabel,
                                           latestNews4Button,
                                           underline4BrokenLineLabel,
                                           latestNews5Button,
                                spacing: 2, alignment: .leading, distribution: .fillEqually),
                               spacing: 15, alignment: .leading, distribution: .equalSpacing)
        stackViewForth.pinExcludingBottom(pinTopToBottomSuperview: stackViewThird, toMainSuperViewLeftRight: contentView)
        stackViewForth.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
//        stackViewForth.VStack(titleArticleNewsLabel,
//                              view1.VStack(imageArticle1,
//                                           articleNews1Button,
//
//                                           spacing: 2, alignment: .leading, distribution: .equalSpacing),
//                               spacing: 15, alignment: .leading, distribution: .equalSpacing)
        stackViewForth.addSubview(imageArticle1)
        stackViewForth.addSubview(userProfileImageView)
        stackViewForth.addSubview(separatorView)
                stackViewForth.VStack(
//                                imageArticle1,
                                articleNews1Button,
            spacing: 2, alignment: .leading, distribution: .fillProportionally)
        addConstraintsWithFormat("V:|-16-[v0]-8-[v1(44)]-16-[v2(1)]|", views: imageArticle1, userProfileImageView, separatorView)
        
        
        
    }
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }


    
}
