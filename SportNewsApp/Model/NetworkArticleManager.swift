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
        // ***************  ***************  ***************  ***************
        // get articles from created server.
        //let urlString = "https://appdeve.site/serv/api/read\(category).php?page=\(page)" // comment/uncomment me with next line of code nr1
        //let checkDatabase = true // this line nr1
        // ***************  ***************  ***************  ***************
        
        // autoposts scraped direclty from original site
        //let urlString = "https://appdeve.site/autoposts/articles/read\(category)Web.php?page=\(page)"// comment/uncomment me with next line of code nr2
        //let checkDatabase = false // this line nr2
        
        // ***************  ***************  ***************  ***************
        // autoposts scraped direclty from original site but has first 10 pages articles scraped in files on the side server
        let urlString = "https://appdeve.site/autoposts/articles/read\(category).php?page=\(page)" // comment/uncomment me with next line of code nr3
        let checkDatabase = false // this line nr3
        // ***************  ***************  ***************  ***************
        
        getArticlesHelper(withUrlString: urlString, checkDatabase: checkDatabase)
    }
    
    private func parseJSONatricles(withData jsonData: Data, checkDatabase: Bool) {
        
        let decoder = JSONDecoder()
        do {
            let articles: ArticlesWebS = try decoder.decode(ArticlesWebS.self, from: jsonData)
            
            for i in 0..<articles.body!.count {
                
                let article = articles.body![i]
                
                let stringId = article.id
                let title = article.title ?? "title"
                let category = article.category ?? "1"
                let shortStory = article.shortStory ?? "descr"
                let fullStory = article.fullStory ?? "loading"
                let timeDate = article.date ?? "date"
                let country = article.country ?? "World"
                
                var imageWebUrl = article.imageThumbLink ?? "error in downloading my comment"

                if checkDatabase == true {
                    // ***************  ***************  ***************  ***************
                                    var imageWebUrlHQ = String()
                                    if let startIndex = fullStory.range(of: "https://football24.ru/uploads/")?.lowerBound {
                                        let endIndex = fullStory.range(of: "|")!.lowerBound
                                        let range = startIndex..<endIndex
                                        imageWebUrlHQ = String(fullStory[range])
                                    }
                    imageWebUrl = imageWebUrlHQ
                    // ***************  ***************  ***************  ***************
                }
                
                let thisArticle = ArticleRealm(id: stringId, title: title, category: category, country: country, shortDescr: shortStory, fullDescr: fullStory, timeAndDate: timeDate, imageWebURL: imageWebUrl)
                
                DispatchQueue.main.async {
                    StorageManager.saveObject(thisArticle)
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func getArticlesHelper(withUrlString urlString :String, checkDatabase: Bool) {
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            if let data = data {
                self.parseJSONatricles(withData: data, checkDatabase: checkDatabase)
            }
        }
        task.resume()
    }
}
