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
        
    private let tableView = UITableView()
    private let reuseIdentifier = "Cell"
    
    var networkArticlesManager = NetworkArticlesManager()
    var articlesRealm: Results<ArticleRealm>!
    let category = "Articles"
    // number of items to be fetched each time (i.e., database LIMIT)
    let itemsPerBatch = 4
    // Where to start fetching items (database OFFSET)
    var currentPage: Int = 1

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .greenMain()
        
        setupFirstLoad()
        setupTableView()
        loadMore()
        setupRefresh()
        
    }
    
    private func setupFirstLoad() {
        articlesRealm = realm.objects(ArticleRealm.self)
        let countArticles = articlesRealm.count
        currentPage = (countArticles / itemsPerBatch) + 1
    }
    private func loadMore() {
        currentPage += 1
        networkArticlesManager.getArticleDataFromWeb(pagNr: currentPage, category: category)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
    private func LoadMoreTop() {
        networkArticlesManager.getArticleDataFromWeb(pagNr: 0, category: category)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    @objc private func refreshNewsData(_ sender: Any) {
        
        DispatchQueue.main.async {
            // Fetch  Data
            self.LoadMoreTop()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
}
extension NewsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesRealm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ArticleTVCell
        let article = articlesRealm[indexPath.row]
        
        // ajusting line between cells
        cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 120.0, bottom: 0.0, right: 25.0)
        cell.layoutMargins = UIEdgeInsets.init(top: 0.0, left: 100.0, bottom: 0.0, right: 0.0)
        cell.setArticle(withArticle: article)
        //cell.setArticleStaticTestInfo()
        return cell
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
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
