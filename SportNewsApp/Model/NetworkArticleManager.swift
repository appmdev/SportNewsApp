//
//  NetworkArticleManager.swift
//  SportNewsApp
//
//  Created by Mac on 23/01/2022.
//


import Foundation

struct NetworkArticlesManager {
    
    func getArticleDataFromWeb(pagNr page: Int, category: String) {
        
        // link for GET Request From server.
        let urlString = "http://appdeve.site/serv/api/read\(category).php?page=\(page)"
        getArticlesHelper(withUrlString: urlString)
    }
    
    private func parseJSONatricles(withData jsonData: Data) {
        
        let decoder = JSONDecoder()
        do {
            let articles: ArticlesWeb = try decoder.decode(ArticlesWeb.self, from: jsonData)
            
            for i in 0..<articles.body!.count {
                
                let article = articles.body![i]
                //print(article)
                
                let stringId = article.id
                let title = article.title ?? "title"
                let category = article.category ?? "1"
                let shortStory = article.shortStory ?? "descr"
                let fullStory = article.fullStory ?? "loading"
                let timeDate = article.date ?? "date"
                var imageWebUrl = String()
                //  ***************  ***************  ***************  ***************
                if let startIndex = fullStory.range(of: "https://football24.ru/uploads/")?.lowerBound {
                    let endIndex = fullStory.range(of: "|")!.lowerBound
                    let range = startIndex..<endIndex
                    imageWebUrl = String(fullStory[range])
                }
                //  ***************  ***************  ***************  ***************
                let thisArticle = ArticleRealm(id: stringId, title: title, category: category, shortDescr: shortStory, fullDescr: fullStory, timeAndDate: timeDate, imageWebURL: imageWebUrl)
                
                DispatchQueue.main.async {
                    StoreageManager.saveObject(thisArticle)
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //  ***************  ***************  ***************  ***************
    // Articles
    private func getArticlesHelper(withUrlString urlString :String) {
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            if let data = data {
                self.parseJSONatricles(withData: data)
            }
        }
        task.resume()
    }
    //  ***************  ***************  ***************  ***************
    
    func getFirstArticleDataFromWeb(firstArticleId: String, category: String){
        
        // link for GET Request
        let urlString = "http://appdeve.site/serv/api/read\(category).php"
        
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            if let jsonData = data {
                let decoder = JSONDecoder()
                do {
                    
                    let articles: ArticlesWeb = try decoder.decode(ArticlesWeb.self, from: jsonData)
                    
                    let firstArticleWebInt = Int(articles.body?.first?.id ?? "0")
                    let firstArticleLocalInt = Int(firstArticleId)
                    
                    if firstArticleWebInt == firstArticleLocalInt {
                        DispatchQueue.main.async {
                            StoreageManager.deleteAll()
                        }
                    }
                    
                    for i in 0..<articles.body!.count {
                        
                        let article = articles.body![i]
                        
                        let stringId = article.id
                        let title = article.title ?? "title"
                        let category = article.category ?? "1"
                        let shortStory = article.shortStory ?? "descr"
                        let fullStory = article.fullStory ?? "loading"
                        let timeDate = article.date ?? "date"
                        var imageWebUrl = String()
                        //  ***************  ***************  ***************  ***************
                        if let startIndex = fullStory.range(of: "https://football24.ru/uploads/")?.lowerBound {
                            let endIndex = fullStory.range(of: "|")!.lowerBound
                            let range = startIndex..<endIndex
                            imageWebUrl = String(fullStory[range])
                        }
                        //  ***************  ***************  ***************  ***************
                        let thisArticle = ArticleRealm(id: stringId, title: title, category: category, shortDescr: shortStory, fullDescr: fullStory, timeAndDate: timeDate, imageWebURL: imageWebUrl)
                        
                        DispatchQueue.main.async {
                            StoreageManager.saveObject(thisArticle)
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
