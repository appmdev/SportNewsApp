//
//  NewsVC.swift
//  SportNewsApp
//
//  Created by Mac on 18/01/2022.
//
//

import UIKit
import RealmSwift

class NewsVC: UIViewController {
    
    // **************  **************  **************
    // MARK: - Refresh Controll
    private let refreshControl = UIRefreshControl()
    // **************  **************  **************
    // MARK: - Hamburger menu
    
    var isSlideInMenuePresented = false
    lazy var slideInMenuePadding: CGFloat = self.view.frame.width * 0.3
    
    lazy var menueBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.leading")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(menuBarButtonTapped))
    
    lazy var menuView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        return view
    }()
    
    private let menuTableView = UITableView()
    // **************  **************  **************
        
    private let tableView = UITableView()
    private let reuseIdentifier = "Cell"
    
    var networkArticlesManager = NetworkArticlesManager()
    var articlesRealm: Results<ArticleRealm>!
    let list = realm.objects(ArticleRealm.self).sorted(byKeyPath: "id", ascending: true)
    let category = "Articles"

    // Where to start fetching items (database OFFSET)
    var currentPage: Int = 2

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .greenMain()
        
        StorageManager.deleteAll()
        setupHamMenu()
        setupFirstLoad()
        networkArticlesManager.getArticleDataFromWeb(pagNr: 1, category: category)
        
        setupNewsView()
        setupMenuTableView()
        setupTableView()
        setupRefresh()
        networkArticlesManager.getArticleDataFromWeb(pagNr: 2, category: category)
    }
    // **************  **************  **************
    // Hamburger menu Func
    private func setupMenuTableView() {
        self.view.addSubview(menuTableView)
        //set delegates
        menuTableView.delegate = self
        menuTableView.dataSource = self
        // set row height
        menuTableView.rowHeight = 240
        menuTableView.rowHeight = UITableView.automaticDimension
        menuTableView.estimatedRowHeight = UITableView.automaticDimension
        
        // register cells
        menuTableView.register(HMenuTVCell.self, forCellReuseIdentifier: HMenuTVCell.identifier)
        
        // hide empty cells at the bottom of the UITableView
        menuTableView.tableFooterView = UIView()
        menuTableView.pin(to: menuView)
        
        menuTableView.backgroundColor = .greenMain()
    }
    private func setupHamMenu() {
        
        navigationItem.setLeftBarButton(menueBarButtonItem, animated: false)
        menuView.pinMenuTo(view, with: slideInMenuePadding)
    }
    @objc func menuBarButtonTapped() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseInOut) {
            self.tableView.frame.origin.x = self.isSlideInMenuePresented ? 0 : self.tableView.frame.width - self.slideInMenuePadding
        } completion: { (finished) in
            //print("Animation finished: \(finished)")
            self.isSlideInMenuePresented.toggle()
        }
    }
    // **************  **************  **************
    
    private func setupFirstLoad() {
        articlesRealm = realm.objects(ArticleRealm.self)
        articlesRealm = articlesRealm.sorted(byKeyPath: "id", ascending: false)
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        //set delegates
        tableView.delegate = self
        tableView.dataSource = self
        // set row height
//        tableView.rowHeight = 250
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        // register cells
        tableView.register(ArticleTVCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // hide empty cells at the bottom of the UITableView
        tableView.tableFooterView = UIView()
        tableView.pin(to: view)
    }
    private func setupNewsView() {
        
        title = "News"
    }
    
    private func setupRefresh() {
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshNewsData(_:)), for: .valueChanged)
        refreshControl.tintColor = .greenMain()
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Articles Data ...")
    }
    private func loadMore() {
        currentPage += 1
        networkArticlesManager.getArticleDataFromWeb(pagNr: currentPage, category: category)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    private func LoadMoreTop() {
        networkArticlesManager.getArticleDataFromWeb(pagNr: 1, category: category)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    @objc private func refreshNewsData(_ sender: Any) {
        
        DispatchQueue.main.async {
            // Fetch  Data
            self.LoadMoreTop()
            self.refreshControl.endRefreshing()
            //self.tableView.reloadData()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
extension NewsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var nrOfRows = 0
        if tableView == self.tableView {
            if articlesRealm.count == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.tableView.reloadData()
                }
                nrOfRows = articlesRealm.count
            } else {
                
                nrOfRows = articlesRealm.count
            }
        }
        if tableView == menuTableView {
            return 3
        }
        return nrOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellToReturn = UITableViewCell()
        
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ArticleTVCell
            let article = articlesRealm[indexPath.row]
            
            // ajusting line between cells
            cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 120.0, bottom: 0.0, right: 25.0)
            cell.layoutMargins = UIEdgeInsets.init(top: 0.0, left: 100.0, bottom: 0.0, right: 0.0)
            cell.setArticle(withArticle: article)
            cellToReturn = cell
        }
        if tableView == menuTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: HMenuTVCell.identifier, for: indexPath) as! HMenuTVCell
            
            // ajusting line between cells
            cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 120.0, bottom: 0.0, right: 25.0)
            cell.layoutMargins = UIEdgeInsets.init(top: 0.0, left: 100.0, bottom: 0.0, right: 0.0)
            if indexPath.row == 0 {
                
                cell.textLabelDescr.text = "All News"
            } else if indexPath.row == 1 {
                
                cell.textLabelDescr.text = "Atricles"
            } else if indexPath.row == 2 {
                
                cell.textLabelDescr.text = "Transfers"
            } else if indexPath.row == 3 {
                
                cell.textLabelDescr.text = "Blogs"
            } else if indexPath.row > 3 {
                
                cell.textLabelDescr.text = "Story \(indexPath.row - 3)"
            }
            return cell
        }
        return cellToReturn
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 100.0 {
            self.loadMore()
        }
    }
    // MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            tableView.deselectRow(at: indexPath, animated: true)
            let article = articlesRealm[indexPath.row]
            showArticleInfoController(withArticle: article)
            tableView.frame.origin.x = 0
            isSlideInMenuePresented = false
        }
        
        if tableView == menuTableView {
            
            if indexPath.row == 0 {
                //Home
                let rootVC = NewsVC()
                navigateNextVC(rootVC: rootVC)
            } else if indexPath.row == 1 {
                //News
                //let rootVC = ArticleVC()
                let rootVC = NewsVC()
                navigateNextVC(rootVC: rootVC)
            } else if indexPath.row == 2 {
                //News
                //let rootVC = TransfersVC()
                let rootVC = NewsVC()
                navigateNextVC(rootVC: rootVC)
            } else if indexPath.row == 3 {
                // Transfers
                tableView.deselectRow(at: indexPath, animated: true)
                let article = articlesRealm[indexPath.row]
                showArticleInfoController(withArticle: article)
            } else if indexPath.row > 3 {
                //Story
                tableView.deselectRow(at: indexPath, animated: true)
                let article = articlesRealm[indexPath.row]
                showArticleInfoController(withArticle: article)
            }
        }
    }
    private func navigateNextVC(rootVC: UIViewController) {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }){
            window.rootViewController = UINavigationController(rootViewController: rootVC);
        }
    }
    private func showArticleInfoController(withArticle article: ArticleRealm) {
        
        let rootVC = DetailNewsVC()
        rootVC.selectedArticle = article
        self.navigationController?.pushViewController(rootVC, animated: true)
    }
}
