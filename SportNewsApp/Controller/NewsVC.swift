//
//  NewsVC.swift
//  SportNewsApp
//
//  Created by Mac on 18/01/2022.
//

import UIKit

class NewsVC: UIViewController {
    
    
    
    private let tableView = UITableView()
    private let reuseIdentifier = "Cell"

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .greenMain()
        setupTableView()
        
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ArticleTVCell
        
        // ajusting line between cells
        cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 120.0, bottom: 0.0, right: 25.0)
        cell.layoutMargins = UIEdgeInsets.init(top: 0.0, left: 100.0, bottom: 0.0, right: 0.0)
        cell.setArticleStaticTestInfo()
        return cell
    }
    
}
