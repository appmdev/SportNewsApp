//
//  StoregeManager.swift
//  SportNewsApp
//
//  Created by Mac on 23/01/2022.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ article: ArticleRealm) {
        try! realm.write {
            realm.create(ArticleRealm.self, value: article, update: .all)
        }
    }

    static func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    static func formatMyDateTime(yourDateTime: String?)-> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let stringDateTimeArticle = yourDateTime ?? "2022-02-09T12:15"
        
        let formattedArticleDate = dateFormatter.date(from: stringDateTimeArticle)
        
        dateFormatter.dateFormat = "HH:mm"
        let articleTime = dateFormatter.string(from: formattedArticleDate!)
        
        // get the current date and time
        let currentDateTime = Date()
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let todayDate = dateFormatter.string(from: currentDateTime)
        let articleCurrentDate = dateFormatter.string(from: formattedArticleDate!)

        if todayDate == articleCurrentDate {
            let finalDateTime = ("Today, " + articleTime)
            return finalDateTime
            //print("Today, " + articleTime)
        } else {
            let test = Date().timeIntervalSinceReferenceDate
            let someOtherDateTime = Date(timeIntervalSinceReferenceDate: test - 86400)
            let yesterdayDate = dateFormatter.string(from: someOtherDateTime)
            if yesterdayDate == articleCurrentDate {
                let finalDateTime = ("Yesterday, " + articleTime)
                return finalDateTime
            } else {
                let finalDateTime = (articleCurrentDate + ", " + articleTime)
                return finalDateTime
            }
        }
    }
}

