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
        // get articles from created server.
        //let urlString = "https://appdeve.site/serv/api/read\(category).php?page=\(page)"
        // autoposts scraped direclty from original site
        let urlString = "https://appdeve.site/autoposts/articles/read\(category).php?page=\(page)"
        
        getArticlesHelper(withUrlString: urlString)
    }
    
    private func parseJSONatricles(withData jsonData: Data) {
        
        let decoder = JSONDecoder()
        do {
            let articles: ArticlesWebS = try decoder.decode(ArticlesWebS.self, from: jsonData)
            
            for i in 0..<articles.body!.count {
                
                let article = articles.body![i]
                //print(article)
                
                let stringId = article.id
                let title = article.title ?? "title"
                let category = article.category ?? "1"
                let shortStory = article.shortStory ?? "descr"
                let fullStory = article.fullStory ?? "loading"
                let timeDate = article.date ?? "date"
                let country = article.country ?? "World"
                let imageWebUrl = article.imageThumbLink ?? "error in downloading my comment"
                
                //  ***************  ***************  ***************  ***************
                //var imageWebUrlHQ = String()
                //if let startIndex = fullStory.range(of: "https://football24.ru/uploads/")?.lowerBound {
                //    let endIndex = fullStory.range(of: "|")!.lowerBound
                //    let range = startIndex..<endIndex
                //    imageWebUrlHQ = String(fullStory[range])
                //}
                //  ***************  ***************  ***************  ***************
                let thisArticle = ArticleRealm(id: stringId, title: title, category: category, country: country, shortDescr: shortStory, fullDescr: fullStory, timeAndDate: timeDate, imageWebURL: imageWebUrl)
                
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
        // get articles from created server.
        //let urlString = "https://appdeve.site/serv/api/read\(category).php"
        // autoposts scraped direclty from original site
        let page = 1
        let urlString = "https://appdeve.site/autoposts/articles/read\(category).php?page=\(page)"
        
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
                    
                    let articles: ArticlesWebS = try decoder.decode(ArticlesWebS.self, from: jsonData)
                    
                    for i in 0..<articles.body!.count {
                        
                        let article = articles.body![i]
                        //print(article)
                        
                        let stringId = article.id
                        let title = article.title ?? "title"
                        let category = article.category ?? "1"
                        let shortStory = article.shortStory ?? "descr"
                        let fullStory = article.fullStory ?? "loading"
                        let timeDate = article.date ?? "date"
                        let country = article.country ?? "World"
                        let imageWebUrl = article.imageThumbLink ?? "error in downloading my comment"
                        
                        //  ***************  ***************  ***************  ***************
                        //var imageWebUrlHQ = String()
                        //if let startIndex = fullStory.range(of: "https://football24.ru/uploads/")?.lowerBound {
                        //    let endIndex = fullStory.range(of: "|")!.lowerBound
                        //    let range = startIndex..<endIndex
                        //    imageWebUrlHQ = String(fullStory[range])
                        //}
                        //  ***************  ***************  ***************  ***************
                        let thisArticle = ArticleRealm(id: stringId, title: title, category: category, country: country, shortDescr: shortStory, fullDescr: fullStory, timeAndDate: timeDate, imageWebURL: imageWebUrl)
                        
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
