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
    
}
